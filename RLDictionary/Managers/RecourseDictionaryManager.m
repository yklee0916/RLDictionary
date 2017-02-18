//
//  RecourseDictionaryManager.m
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "RecourseDictionaryManager.h"

@implementation RecourseDictionaryManager

- (void)requestRecourseDictionaryWithString:(NSString *)string completionHandler:(void (^)(NSString *resultJsonString, NSError *error))completionHandler {
    
    NSString * language = @"en";
    NSString * word_id = [string lowercaseString]; //word id is case sensitive and lowercase is required
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://od-api.oxforddictionaries.com:443/api/v1/entries/%@/%@", language, word_id]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"63eee522" forHTTPHeaderField:@"app_id"];
    [request setValue:@"51bfff825e6a24b3313969611a34e487" forHTTPHeaderField:@"app_key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSString *jsonString = nil;
                                      if(data) {
                                          jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      }
                                      if(completionHandler) {
                                          completionHandler(jsonString, error);
                                      }
                                  }];
    [task resume];
}

- (void)testJson {
    //    NSString *jsonString = {
    //        "metadata": {
    //            "provider": "Oxford University Press"
    //        },
    //        "results": [
    //                    {
    //                        "id": "wordbook",
    //                        "language": "en",
    //                        "lexicalEntries": [
    //                                           {
    //                                               "entries": [
    //                                                           {
    //                                                               "grammaticalFeatures": [
    //                                                                                       {
    //                                                                                           "text": "Singular",
    //                                                                                           "type": "Number"
    //                                                                                       }
    //                                                                                       ],
    //                                                               "senses": [
    //                                                                          {
    //                                                                              "definitions": [
    //                                                                                              "a study book containing lists of words and meanings or other related information."
    //                                                                                              ],
    //                                                                              "id": "m_en_gb0959600.001"
    //                                                                          }
    //                                                                          ]
    //                                                           }
    //                                                           ],
    //                                               "language": "en",
    //                                               "lexicalCategory": "Noun",
    //                                               "pronunciations": [
    //                                                                  {
    //                                                                      "audioFile": "http://audio.oxforddictionaries.com/en/mp3/wordbook_gb_1_8.mp3",
    //                                                                      "dialects": [
    //                                                                                   "British English"
    //                                                                                   ],
    //                                                                      "phoneticNotation": "IPA",
    //                                                                      "phoneticSpelling": "ˈwəːdbʊk"
    //                                                                  }
    //                                                                  ],
    //                                               "text": "wordbook"
    //                                           }
    //                                           ],
    //                        "type": "headword",
    //                        "word": "wordbook"
    //                    }
    //                    ]
    //    }
}

@end
