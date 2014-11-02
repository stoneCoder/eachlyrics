//
//  FFmpegDecoder.m
//  FFmpegAudioTest
//
//  Created by Pontago on 12/06/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FFmpegDecoder.h"
#define AVCODEC_MAX_AUDIO_FRAME_SIZE 192000
@implementation FFmpegDecoder

@synthesize audioCodecContext_, audioBuffer_;

- (id)init {
    if (self = [super init]) {
      /*注册所有可解码类型*/
      av_register_all();

      audioStreamIndex_ = -1;
      audioBufferSize_ = AVCODEC_MAX_AUDIO_FRAME_SIZE;
      audioBuffer_ = av_malloc(audioBufferSize_);
      av_init_packet(&packet_);
      inBuffer_ = NO;
    }

    return self;
}

- (void)dealloc {
    if (audioCodecContext_ != NULL) avcodec_close(audioCodecContext_);
    if (inputFormatContext_ != NULL) avformat_close_input(&inputFormatContext_);
    av_free_packet(&packet_);
    audioBuffer_ = nil;
    av_free(audioBuffer_);
}

- (NSInteger)loadFile:(NSString*)filePath {
    if (avformat_open_input(&inputFormatContext_, [filePath UTF8String], NULL, NULL) != 0) {
      NSLog(@"Could not load input file.");
      return -1;
    }

    if (avformat_find_stream_info(inputFormatContext_, NULL) < 0) {
      NSLog(@"The file format was not supported. (avformat_find_stream_info)");
      return -2;
    }
    
    av_dump_format(inputFormatContext_, 0, [filePath UTF8String], 0);
    
    for (NSInteger i = 0; i < inputFormatContext_->nb_streams; i++) {
      if (inputFormatContext_->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
        audioStreamIndex_ = i;
        break;
      }
    }

    if (audioStreamIndex_ == -1) {
      NSLog(@"Not found aduio stream.");
      return -3;
    }
    else {
      audioStream_ = inputFormatContext_->streams[audioStreamIndex_];
      audioCodecContext_ = audioStream_->codec;

      AVCodec *codec = avcodec_find_decoder(audioCodecContext_->codec_id);

      if (codec == NULL) {
        NSLog(@"Not found audio codec.");
        return -4;
      }
        
      if (avcodec_open2(audioCodecContext_, codec, NULL) < 0) {
        NSLog(@"Could not open audio codec.");
        return -5;
      }
    }
    
    NSLog(@"ggggg------->%d",audioCodecContext_->sample_fmt);
    
    
    inputFilePath_ = filePath;

    return 0;
}

- (NSTimeInterval)duration {
    return inputFormatContext_ == NULL ? 
      0.0f : (NSTimeInterval)inputFormatContext_->duration / AV_TIME_BASE;
}

- (void)seekTime:(NSTimeInterval)seconds {
    inBuffer_ = NO;
    av_free_packet(&packet_);
    currentPacket_ = packet_;

    av_seek_frame(inputFormatContext_, -1, seconds * AV_TIME_BASE, 0);
}

- (AVPacket*)readPacket {
    if (currentPacket_.size > 0 || inBuffer_) return &currentPacket_;

    av_free_packet(&packet_);

    for (;;) {
      NSInteger ret = av_read_frame(inputFormatContext_, &packet_);
      if (ret == AVERROR(EAGAIN)) {
        continue;
      }
      else if (ret < 0) {
        return NULL;
      }

      if (packet_.stream_index != audioStreamIndex_) {
        av_free_packet(&packet_);
        continue;
      }

      if (packet_.dts != AV_NOPTS_VALUE) {
        packet_.dts += av_rescale_q(0, AV_TIME_BASE_Q, audioStream_->time_base);
      }
      if (packet_.pts != AV_NOPTS_VALUE) {
        packet_.pts += av_rescale_q(0, AV_TIME_BASE_Q, audioStream_->time_base);
      }

      break;
    }

    currentPacket_ = packet_;

    return &currentPacket_;
}

- (NSInteger)decode {
    if (inBuffer_) return decodedDataSize_;
    AVFrame *frame = avcodec_alloc_frame();
    decodedDataSize_ = 0;
    AVPacket *packet = [self readPacket];
    
//    aformat = avfilter_get_by_name("aformat");
//    if (!aformat) {
//        NSLog(@"Could not find the aformat filter.\n");
//        return;
//    }
//    aformat_ctx = avfilter_graph_alloc_filter(filter_graph, aformat, "aformat");
//    if (!aformat_ctx) {
//        fprintf(stderr, "Could not allocate the aformat instance.\n");
//        return AVERROR(ENOMEM);
//    }
//    /* A different way of passing the options is as key/value pairs in a
//     * dictionary. */
//    
//    sprintf(args, "sample_fmts=s16");
//    err = avfilter_init_str(aformat_ctx, args);
//    if (err < 0) {
//        fprintf(stderr, "Could not initialize the aformat filter.\n");
//        return err;
//    }
    
    while (packet && packet->size > 0) {
      if (audioBufferSize_ < FFMAX(packet->size * sizeof(*audioBuffer_), AVCODEC_MAX_AUDIO_FRAME_SIZE)) {
        audioBufferSize_ = FFMAX(packet->size * sizeof(*audioBuffer_), AVCODEC_MAX_AUDIO_FRAME_SIZE);
        av_free(audioBuffer_);
        audioBuffer_ = av_malloc(audioBufferSize_);
      }
      decodedDataSize_ = audioBufferSize_;
      NSInteger len = avcodec_decode_audio4(audioCodecContext_, frame, &decodedDataSize_, packet);

      if (len < 0) {
        NSLog(@"Could not decode audio packet.");
        return 0;
      }
        
      if (decodedDataSize_ <= 0) {
        NSLog(@"Decoding was completed.");
        packet = NULL;
        return 0;
      }
        packet->size -= len;
        packet->data += len;
       
        //int data_size = av_samples_get_buffer_size(NULL, audioCodecContext_->channels, frame->nb_samples, audioCodecContext_->sample_fmt, 1);
        if (audioCodecContext_->sample_fmt == AV_SAMPLE_FMT_S16P)
        {
            int data_size = av_samples_get_buffer_size(NULL, audioCodecContext_->channels, frame->nb_samples, audioCodecContext_->sample_fmt, 1);
            char *data = (char *)av_malloc(data_size);
            short *sample_buffer = (short *)frame->data[0];
            for (int i = 0; i < data_size/2; i++)
            {
                data[i*2] = (char)(sample_buffer[i/2] & 0xFF);
                data[i*2+1] = (char)((sample_buffer[i/2] >>8) & 0xFF);
            }
            audioBuffer_ = (uint8_t *)data;
            decodedDataSize_ = data_size;
            
            av_free(data);
        }else{
            decodedDataSize_ = frame->linesize[0];
            audioBuffer_ = frame->extended_data[0];
        }
        
        inBuffer_ = YES;
        break;
    }
    return decodedDataSize_;
}

- (void)nextPacket {
    inBuffer_ = NO;
}

/*获取音频文件信息*/
-(void)getMusicInfo
{
    AVDictionaryEntry *m = NULL;
    char *key;
    char *value;
    while((m = av_dict_get(inputFormatContext_->metadata,"",m,AV_DICT_IGNORE_SUFFIX))){
        key = m->key;
        value = m->value;
        NSLog(@"%@------------>%@",[NSString stringWithUTF8String:m->key],[NSString stringWithUTF8String:m->value]);
    }
}

@end
