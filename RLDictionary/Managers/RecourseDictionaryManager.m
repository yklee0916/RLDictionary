//
//  RecourseDictionaryManager.m
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "RecourseDictionaryManager.h"
#import "OxfordDictionariesResponse.h"
#import "Result.h"

@interface RecourseDictionaryManager ()

@property (nonatomic, strong) NSArray <Sense *> *senses;

@end

@implementation RecourseDictionaryManager

- (NSUInteger)count {
    return self.senses.count;
}

- (NSUInteger)exampleCountAtIndex:(NSUInteger)index {
    return [self senseAtIndex:index].examples.count;
}

- (Sense *)senseAtIndex:(NSUInteger)index {
    return [self.senses objectAtIndex:index];
}

- (void)requestRecourseDictionaryWithString:(NSString *)string completionHandler:(void (^)(OxfordDictionariesResponse *response, NSError *error))completionHandler {
    
    if(!string) {
        NSError *error = [NSError errorWithDomain:@"Input string is empty" code:-1001 userInfo:nil];
        if(completionHandler) completionHandler(nil, error);
        return ;
    }
    
//    NSString *responseJsonString = self.testJson;
//    NSError* err = nil;
//    OxfordDictionariesResponse *responseData = [[OxfordDictionariesResponse alloc] initWithString:responseJsonString error:&err];
//    self.senses = [[[responseData resultAtIndex:0] lexicalEntryAtIndex:0] entryAtIndex:0].senses;
//    
//    if(completionHandler) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completionHandler(responseData, nil);
//        });
//    }
//    return ;
    
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
                                      
                                      OxfordDictionariesResponse *responseData = nil;
                                      if(data) {
                                          NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSError* err = nil;
                                          responseData = [[OxfordDictionariesResponse alloc] initWithString:jsonString error:&err];
                                      }
                                      
                                      
                                      self.senses = [[[responseData resultAtIndex:0] lexicalEntryAtIndex:0] entryAtIndex:0].senses;
                                      
                                      if(completionHandler) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              completionHandler(responseData, error);
                                          });
                                      }
                                  }];
    [task resume];
}

- (NSString *)testJson {
    return @"{ \"metadata\": { \"provider\": \"Oxford University Press\" }, \"results\": [ { \"id\": \"lead\", \"language\": \"en\", \"lexicalEntries\": [ { \"entries\": [ { \"etymologies\": [ \"Old English lǣdan, of Germanic origin; related to Dutch leiden and German leiten, also to load and lode\" ], \"grammaticalFeatures\": [ { \"text\": \"Transitive\", \"type\": \"Subcategorization\" }, { \"text\": \"Present\", \"type\": \"Tense\" } ], \"homographNumber\": \"100\", \"senses\": [ { \"definitions\": [ \"cause (a person or animal) to go with one by holding them by the hand, a halter, a rope, etc. while moving forward:\" ], \"examples\": [ { \"text\": \"she emerged leading a bay horse\" } ], \"id\": \"m_en_gb0461360.001\", \"subsenses\": [ { \"definitions\": [ \"show (someone or something) the way to a destination by going in front of or beside them:\" ], \"examples\": [ { \"text\": \"she stood up and led her friend to the door\" } ], \"id\": \"m_en_gb0461360.002\" } ] }, { \"definitions\": [ \"be a route or means of access to a particular place or in a particular direction:\" ], \"examples\": [ { \"text\": \"a farm track led off to the left\" }, { \"text\": \"the door led to a better-lit corridor\" } ], \"id\": \"m_en_gb0461360.004\", \"subsenses\": [ { \"definitions\": [ \"be a reason or motive for (someone):\" ], \"examples\": [ { \"text\": \"nothing that I have read about the case leads me to the conclusion that anything untoward happened\" }, { \"text\": \"a fascination for art led him to start a collection of paintings\" } ], \"id\": \"m_en_gb0461360.005\" }, { \"definitions\": [ \"culminate or result in (a particular event or consequence):\" ], \"examples\": [ { \"text\": \"closing the plant will lead to 300 job losses\" }, { \"text\": \"fashioning a policy appropriate to the situation entails understanding the forces that led up to it\" } ], \"id\": \"m_en_gb0461360.006\" } ] }, { \"definitions\": [ \"be in charge or command of:\" ], \"examples\": [ { \"text\": \"a military delegation was led by the Chief of Staff\" } ], \"id\": \"m_en_gb0461360.008\", \"subsenses\": [ { \"definitions\": [ \"organize and direct:\" ], \"examples\": [ { \"text\": \"the conference included sessions led by people with personal knowledge of the area\" } ], \"id\": \"m_en_gb0461360.009\" }, { \"definitions\": [ \"be the principal player of (a group of musicians):\" ], \"domains\": [ \"Music\" ], \"examples\": [ { \"text\": \"since the forties he has led his own big bands\" } ], \"id\": \"m_en_gb0461360.010\" }, { \"definitions\": [ \"set (a process) in motion:\" ], \"examples\": [ { \"text\": \"they are waiting for an expansion of world trade to lead a recovery\" } ], \"id\": \"m_en_gb0461360.011\" }, { \"definitions\": [ \"start:\" ], \"examples\": [ { \"text\": \"Ned leads off with a general survey of the objectives\" }, { \"text\": \"the radio news led with the murder\" } ], \"id\": \"m_en_gb0461360.012\" }, { \"definitions\": [ \"make an attack with (a particular punch or fist):\" ], \"domains\": [ \"Boxing\" ], \"examples\": [ { \"text\": \"Adam led with a left\" } ], \"id\": \"m_en_gb0461360.013\" }, { \"definitions\": [ \"(of a base runner) be in a position to run from a base while standing off the base.\" ], \"domains\": [ \"Baseball\" ], \"id\": \"m_en_gb0461360.083\" }, { \"definitions\": [ \"(in card games) play (the first card) in a trick or round of play:\" ], \"domains\": [ \"Cards\" ], \"examples\": [ { \"text\": \"he led the ace and another heart\" }, { \"text\": \"it's your turn to lead\" } ], \"id\": \"m_en_gb0461360.014\" } ] }, { \"definitions\": [ \"have the advantage over competitors in a race or game:\" ], \"domains\": [ \"Sport\" ], \"examples\": [ { \"text\": \"he followed up with a break of 105 to lead 3-0\" }, { \"text\": \"the Wantage jockey was leading the field\" } ], \"id\": \"m_en_gb0461360.015\", \"subsenses\": [ { \"definitions\": [ \"be superior to (competitors or colleagues):\" ], \"examples\": [ { \"text\": \"there will be specific areas or skills in which other nations lead the world\" } ], \"id\": \"m_en_gb0461360.016\" } ] }, { \"definitions\": [ \"have or experience (a particular way of life):\" ], \"examples\": [ { \"text\": \"she's led a completely sheltered life\" } ], \"id\": \"m_en_gb0461360.017\" } ] } ], \"language\": \"en\", \"lexicalCategory\": \"Verb\", \"pronunciations\": [ { \"audioFile\": \"http://audio.oxforddictionaries.com/en/mp3/lead_gb_1.mp3\", \"dialects\": [ \"British English\" ], \"phoneticNotation\": \"IPA\", \"phoneticSpelling\": \"liːd\" } ], \"text\": \"lead\" }, { \"entries\": [ { \"grammaticalFeatures\": [ { \"text\": \"Singular\", \"type\": \"Number\" } ], \"homographNumber\": \"101\", \"pronunciations\": [ { \"audioFile\": \"http://audio.oxforddictionaries.com/en/mp3/lead_gb_1.mp3\", \"dialects\": [ \"British English\" ], \"phoneticNotation\": \"IPA\", \"phoneticSpelling\": \"liːd\" } ], \"senses\": [ { \"definitions\": [ \"the initiative in an action; an example for others to follow:\" ], \"examples\": [ { \"text\": \"Britain is now taking the lead in environmental policies\" } ], \"id\": \"m_en_gb0461360.020\", \"subsenses\": [ { \"definitions\": [ \"a piece of information that may help in the resolution of a problem:\" ], \"examples\": [ { \"text\": \"I have a lead on a job that sounds really promising\" }, { \"text\": \"detectives investigating the murder are chasing new leads\" } ], \"id\": \"m_en_gb0461360.021\" }, { \"definitions\": [ \"someone or something that may be useful, especially a potential customer or business opportunity:\" ], \"domains\": [ \"Commerce\" ], \"examples\": [ { \"text\": \"setting up a social networking page can help you get numerous leads\" }, { \"text\": \"the goal of marketing is to generate leads so the sales people can close them\" } ], \"id\": \"m_en_gb0461360.064\" }, { \"definitions\": [ \"(in card games) an act or right of playing first in a trick or round of play:\" ], \"domains\": [ \"Cards\" ], \"examples\": [ { \"text\": \"it's your lead\" } ], \"id\": \"m_en_gb0461360.022\" }, { \"definitions\": [ \"the card played first in a trick or round:\" ], \"domains\": [ \"Cards\" ], \"examples\": [ { \"text\": \"the ♦8 was an inspired lead\" } ], \"id\": \"m_en_gb0461360.023\" } ] }, { \"definitions\": [ \"a position of advantage in a contest; first place:\" ], \"domains\": [ \"Sport\" ], \"examples\": [ { \"text\": \"they were beaten 5-3 after twice being in the lead\" }, { \"text\": \"the team burst into life and took the lead\" } ], \"id\": \"m_en_gb0461360.024\", \"subsenses\": [ { \"definitions\": [ \"an amount by which a competitor is ahead of the others:\" ], \"domains\": [ \"Sport\" ], \"examples\": [ { \"text\": \"the team held a slender one-goal lead\" } ], \"id\": \"m_en_gb0461360.025\" } ] }, { \"definitions\": [ \"the chief part in a play or film:\" ], \"domains\": [ \"Theatre\", \"Film\" ], \"examples\": [ { \"text\": \"the lead role\" }, { \"text\": \"she had the lead in a new film\" } ], \"id\": \"m_en_gb0461360.026\", \"subsenses\": [ { \"definitions\": [ \"the person playing the chief part:\" ], \"domains\": [ \"Theatre\", \"Film\" ], \"examples\": [ { \"text\": \"he still looked like a romantic lead\" } ], \"id\": \"m_en_gb0461360.027\" }, { \"definitions\": [ \"the chief performer or instrument of a specified type:\" ], \"domains\": [ \"Music\" ], \"examples\": [ { \"text\": \"a lead guitarist\" } ], \"id\": \"m_en_gb0461360.028\" }, { \"definitions\": [ \"the item of news given the greatest prominence in a newspaper, broadcast, etc.:\" ], \"domains\": [ \"Journalism\" ], \"examples\": [ { \"text\": \"the ‘pensions revolution’ is the lead in the Times\" }, { \"text\": \"the lead story on CNN\" } ], \"id\": \"m_en_gb0461360.029\" }, { \"definitions\": [ \"the opening sentence or paragraph of a news article, summarizing the most important aspects of the story:\" ], \"domains\": [ \"Journalism\" ], \"examples\": [ { \"text\": \"the newswire will be offering two different leads for certain stories, so editors can pick and choose\" } ], \"id\": \"m_en_gb0461360.065\", \"regions\": [ \"US\" ], \"variantForms\": [ { \"text\": \"lede\" } ] } ] }, { \"definitions\": [ \"a strap or cord for restraining and guiding a dog or other domestic animal:\" ], \"examples\": [ { \"text\": \"the dog is our constant walking companion and is always kept on a lead\" } ], \"id\": \"m_en_gb0461360.030\", \"regions\": [ \"British\" ] }, { \"definitions\": [ \"a wire that conveys electric current from a source to an appliance, or that connects two points of a circuit together.\" ], \"domains\": [ \"Electrical\" ], \"id\": \"m_en_gb0461360.031\", \"regions\": [ \"British\" ] }, { \"definitions\": [ \"the distance advanced by a screw in one turn.\" ], \"domains\": [ \"Mechanics\" ], \"id\": \"m_en_gb0461360.032\" }, { \"definitions\": [ \"an artificial watercourse leading to a mill.\" ], \"id\": \"m_en_gb0461360.033\", \"subsenses\": [ { \"definitions\": [ \"a channel of water in an ice field.\" ], \"domains\": [ \"Nautical\" ], \"id\": \"m_en_gb0461360.034\" } ] } ] }, { \"etymologies\": [ \"Old English lēad, of West Germanic origin; related to Dutch lood lead and German Lot plummet, solder\" ], \"grammaticalFeatures\": [ { \"text\": \"Singular\", \"type\": \"Number\" } ], \"homographNumber\": \"200\", \"pronunciations\": [ { \"audioFile\": \"http://audio.oxforddictionaries.com/en/mp3/lead_gb_2.mp3\", \"dialects\": [ \"British English\" ], \"phoneticNotation\": \"IPA\", \"phoneticSpelling\": \"lɛd\" } ], \"senses\": [ { \"definitions\": [ \"a soft, heavy, ductile bluish-grey metal, the chemical element of atomic number 82. It has been used in roofing, plumbing, ammunition, storage batteries, radiation shields, etc., and its compounds have been used in crystal glass, as an anti-knock agent in petrol, and (formerly) in paints.\" ], \"domains\": [ \"Element\" ], \"id\": \"m_en_gb0461370.001\", \"subsenses\": [ { \"definitions\": [ \"used figuratively as a symbol of something heavy:\" ], \"examples\": [ { \"text\": \"Joe's feet felt like lumps of lead\" } ], \"id\": \"m_en_gb0461370.002\" } ], \"variantForms\": [ { \"text\": \"Pb\" } ] }, { \"definitions\": [ \"an item or implement made of lead, in particular:\" ], \"id\": \"m_en_gb0461370.003\", \"subsenses\": [ { \"definitions\": [ \"sheets or strips of lead covering a roof.\" ], \"domains\": [ \"Building\" ], \"id\": \"m_en_gb0461370.004\", \"regions\": [ \"British\" ] }, { \"definitions\": [ \"a piece of lead-covered roof.\" ], \"id\": \"m_en_gb0461370.005\", \"regions\": [ \"British\" ] }, { \"definitions\": [ \"lead frames holding the glass of a lattice or stained-glass window.\" ], \"id\": \"m_en_gb0461370.006\" }, { \"definitions\": [ \"a lump of lead suspended on a line to determine the depth of water.\" ], \"domains\": [ \"Nautical\" ], \"id\": \"m_en_gb0461370.007\" } ] }, { \"definitions\": [ \"graphite used as the part of a pencil that makes a mark:\" ], \"examples\": [ { \"text\": \"scrawls done with a bit of pencil lead\" } ], \"id\": \"m_en_gb0461370.008\" }, { \"definitions\": [ \"a blank space between lines of print.\" ], \"domains\": [ \"Printing\" ], \"id\": \"m_en_gb0461370.010\" } ] } ], \"language\": \"en\", \"lexicalCategory\": \"Noun\", \"text\": \"lead\" } ], \"type\": \"headword\", \"word\": \"lead\" } ] }";
}

@end
