//
//  FlickrEngine.h
//  MKNetworkKit-iOS-Demo
//
//  Created by Mugunth Kumar (@mugunthkumar) on 22/1/12.
//  Copyright (C) 2011-2020 by Steinlogic

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#warning Insert your flickr key here
#define FLICKR_KEY @"210af0ac7c5dad997a19f7667e5779d3"
#define FLICKR_IMAGE_URL(__TAG__) [NSString stringWithFormat:@"services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=200&format=json&nojsoncallback=1", FLICKR_KEY, __TAG__]

@interface FlickrEngine : MKNetworkEngine

typedef void (^FlickrImagesResponseBlock)(NSMutableArray* imageURLs);
-(void) imagesForTag:(NSString*) tag onCompletion:(FlickrImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock;
@end
