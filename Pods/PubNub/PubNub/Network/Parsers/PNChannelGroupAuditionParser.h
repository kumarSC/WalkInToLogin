#import <Foundation/Foundation.h>
#import "PNParser.h"


/**
 @brief      Class suitable to handle and process \b PubNub service response on channels for group
             and channel groups list audit request.
 @discussion Handle and pre-process provided server data to fetch operation result from it.
 
 @code
 @endcode
 Expected output for channel groups list audit:
 
 @code
 {
  "channel-groups": [
                     NSString,
                     ...
                    ]
 }
 @endcode
 Expected output for group channels list audit:
 
 @code
 {
  "channels": [
               NSString,
               ...
              ]
 }
 @endcode
 
 @author Sergey Mamontov
 @since 4.0
 @copyright © 2009-2015 PubNub, Inc.
 */
@interface PNChannelGroupAuditionParser : NSObject <PNParser>


#pragma mark - 


@end
