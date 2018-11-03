//
//  EHOMETermsTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/1.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMETermsTableViewController.h"
#import "EHOMETermsTitleTableViewCell.h"
#import "EHOMETermsContentTableViewCell.h"


static NSString *titleCellId = @"EHOMETermsTitleTableViewCell";
static NSString *contentCellId = @"EHOMETermsContentTableViewCell";

@interface EHOMETermsTableViewController ()

@property (nonatomic, strong) NSArray *termArray;

@end

@implementation EHOMETermsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Service Agreement", @"Profile", nil);
    

    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMETermsTitleTableViewCell" bundle:nil] forCellReuseIdentifier:titleCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMETermsContentTableViewCell" bundle:nil] forCellReuseIdentifier:contentCellId];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, 30)];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.termArray = [self getData];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.termArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        EHOMETermsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (!cell) {
            cell = [[EHOMETermsTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellId];
        }
        
        if (indexPath.section == 0) {
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            cell.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        cell.titleLabel.text = self.termArray[indexPath.section][@"title"];
        
        return cell;
    }else{
        EHOMETermsContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellId];
        if (!cell) {
            cell = [[EHOMETermsContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCellId];
        }
        
        cell.contentLabel.text = self.termArray[indexPath.section][@"content"];
        
        return cell;
    }

}


-(NSArray *)getData{
    
    NSArray *terms;
    
    switch (CurrentApp) {
        case eHome:
            {
                terms = @[@{@"title":@"Terms of Use",
                            @"content":@"Thank you for building your smart home with eHome!\n\nThese Terms and Conditions of Use (the \"Terms of Use\") apply to the eHome and all associated sites linked to www.whatie.com by Whatie. BY USING THE EHOME, YOU AGREE TO THESE TERMS OF USE; IF YOU DO NOT AGREE, DO NOT USE THE APP."
                            },
                          @{@"title":@"Modification to Terms",
                            @"content":@"Whatie reserves the right, at its sole discretion, to change, modify, add or remove portions of these Terms of Use, at any time. In the event that we need to change the Services, we will place a notice in the Terms and may also send you an email. It is your responsibility to check these Terms of Use periodically for changes. Your continued use of the Service following the posting of changes will mean that you accept and agree to the changes. As long as you comply with these Terms of Use, Whatie grants you a personal, non-exclusive, non-transferable, limited privilege to use the Service."
                            },
                          @{@"title":@"Account Registration",
                            @"content":@"In order to use the Services, you may be required to sign up for an account. To sign up for an account, you must provide a username and password. You may not sign up using a name that you do not have the right to use, or another person's name with the intent to impersonate that person."
                            },
                          @{@"title":@"Representations and Warranties",
                            @"content":@"You represent and warrant that you are of legal age to enter into a binding contract. If not, you represent and warrant that you have acquired parental consent and that they have read and agreed to these Terms on your behalf. If you're using the Services on behalf of an organization or entity, you represent and warrant that you are authorized to agree to these Terms on their behalf and bind them to these Terms. You may only use the Services for your personal, non-commercial use. Your use must comply with all laws that apply to you. You may not use these Services if applicable laws prohibit such use."
                            },
                          @{@"title":@"Restrictions on Use",
                            @"content":@"During your usage of the Services, you may create connections between our hardware devices, third-party hardware devices, our Services, and/or third-party services. You agree that you will not connect to the Services any hardware devices or third-party services in a manner that could be dangerous to any person(s), or which could cause damage to or loss of any property. Your use of the Services is subject to the following additional restrictions:\n\nYou may not use the Services or interact with the Services in a manner that:\n\n1. Infringes or violates the intellectual property rights or any other rights of anyone else;\n\n2. Violates any law or regulation;\n\n3. Is harmful, fraudulent, deceptive, threatening, harassing, defamatory, obscene, or otherwise objectionable;\n\n4. Jeopardizes the security of your account or anyone else's;\n\n5. Attempts, in any manner, to obtain the password, account, or other security information from any other user;\n\n6. Violates the security of any computer network, or cracks any passwords or security encryption codes;\n\n7. Runs any form of auto-responder or \"spam\" on the Services, or that otherwise interfere with the proper working of the Services (including by placing an unreasonable load on the Services' infrastructure);\n\n8. \"Crawls,\" \"scrapes,\" or \"spiders\" any page or portion of the Services (through use of manual or automated means);\n\n9. Copies or stores any significant portion of the Content (as defined below);\n\n10. Decompiles, reverse engineers, or otherwise attempts to obtain the source code of the Services."
                            },
                          @{@"title":@"Content on the Services",
                            @"content":@"\"Content\" is all the of the information collected during your use of the Services. It includes information provided by you, by other users, by hardware devices connected to the Services, and by third-party devices and services connected to the Services. It also includes any information we provide into the Services, as well as information derived from or aggregated from any and all information provided to the Services."
                            },
                          @{@"title":@"Third-Party Services",
                            @"content":@"You accept that Whatie is not responsible for the risks you take associated with links or connections to third-party applications or services. You understand that such third-party services may or may not carry their own terms, conditions, privacy policies or other policies that may or may not be related to these Services. We encourage you to be aware of such agreements when you connect third-party services to these Services. We cannot and do not have control over, nor do we assume any responsibility or risk for content, accuracy, practices, opinions, or policies of any third-party websites, applications, or services that you may be exposed to when you interact with the Services. Your interactions with third-party organizations and/or individuals found on or through the Services are solely between you and such organizations and/or individuals found on or through the Services are solely between you and such organizations and/or individuals. You agree that we shall not be responsible for any liability for any loss or damage associated with any such interaction."
                            },
                          @{@"title":@"Termination",
                            @"content":@"You are free to stop using the Services at any time. You understand and agree that we may or may not delete your Content in the event that you stop using the Services. Account termination may result in destruction of any Personal Submissions and/or Device Submissions associated with your account; however, you understand and agree that we may retain copies of such Content indefinitely. In the event that we elect to terminate your account, we will try to provide advance notice to you prior to termination so that you are able to retrieve any important Content stored in your account. You understand and agree that we may provide no advanced notice for any reason, but usually because it would be impractical, illegal, not in the interest of someone's safety or security, or otherwise harmful to the rights or property of Whatie.\n\nIf any provision of this agreement is found to be unenforceable or invalid, that provision will be limited or eliminated, to the minimum extent necessary, so that these Terms shall otherwise remain in full force and effect and enforceable."
                            },
                          @{@"title":@"Additional Terms and Conditions",
                            @"content":@"These Terms apply to your use of all the Services including applications available via both the Apple, Inc. (\"Apple\") App Store (the \"Application\") and the Google, Inc. (\"Google\") Play Store (also the \"Application\"), but the following additional terms also apply to the Application:\n\n1. The Application is licensed to you on a limited, non-exclusive, non-transferable, non-sublicensable basis, solely to be used in connection with the Services for your private, personal, noncommercial use, subject to all the Terms as they are applicable to the Services;\n\n2. Both you and Whatie acknowledge that the Terms are concluded between you and Whatie only, and not with Apple or Google, and that Apple or Google is not responsible for the Application or the Content;\n\n3. You will only use the Application in connection with an Apple or Google device that you own or control;\n\n4. You acknowledge that Apple or Google has no obligation whatsoever to furnish any maintenance and support services with respect to the Application;\n\n5. In the event of any failure of the Application to conform to any applicable warranty, including those implied by the law, you may notify Apple or Google of such failure; upon notification, Apple's or Google's sole warranty obligation to you will be to refund you the purchase price, if any, of the Application;\n\n6. You acknowledge and agree that Whatie, and neither Apple nor Google, is responsible for addressing any claims you or any third-party may have in relation to the Application;\n\n7. You acknowledge and agree that, in the event of any third-party claim that the Application or your possession and use of the Application infringes that third-party's intellectual property rights, Whatie, and neither Apple nor Google, will be responsible for the investigation;\n\n8. Both you and Whatie acknowledge and agree that, in your use of the Application, you will comply with any applicable third-party terms of agreement which may affect or be affected by such use;\n\n9. Both you and Whatie acknowledge and agree that Apple and Apple's subsidiaries as well as Google and Google's subsidiaries are third-party beneficiaries of this Agreement, and that upon your acceptance of this Agreement, Apple or Google will have the right (and will be deemed to have accepted the right) to enforce this Agreement against you as third-party beneficiary hereof."
                            },
                          @{@"title":@"Risk of Loss; Insurance",
                            @"content":@"You acknowledge and agree that your use of the services (including, without limitation, using the services to secure or otherwise control access to any real or personal property) is solely at your own risk, and that you accept responsibility for all losses, damages, and expenses arising out of such use. You are responsible for maintaining insurance covering all loss, damage, or expense, whether for property damage, or expense, whether for property damage, personal injury (including death), economic losses, or any other form of loss, damage, or expense arising out of or from (i) these terms, or (ii) the services."
                            },
                          @{@"title":@"Assignment",
                            @"content":@"You may not assign, delegate, or transfer these Terms or your rights or obligations hereunder, or your Services account, in any way (by operation of law or otherwise) without Whatie's prior written consent. We may transfer, assign, or delegate these Terms and our rights and obligations without consent."
                            },
                          ];
            }
            break;
        case Geek:
        {
            terms = @[@{@"title":@"Terms of Use",
                        @"content":@"Thank you for building your smart home with Geek Home!\n\nThese Terms and Conditions of Use (the \"Terms of Use\") apply to the Geek Home and all associated sites linked to http://www.proxelle.com by Proxelle. BY USING THE GEEK HOME, YOU AGREE TO THESE TERMS OF USE; IF YOU DO NOT AGREE, DO NOT USE THE APP."
                        },
                      @{@"title":@"Modification to Terms",
                        @"content":@"Proxelle reserves the right, at its sole discretion, to change, modify, add or remove portions of these Terms of Use, at any time. In the event that we need to change the Services, we will place a notice in the Terms and may also send you an email. It is your responsibility to check these Terms of Use periodically for changes. Your continued use of the Service following the posting of changes will mean that you accept and agree to the changes. As long as you comply with these Terms of Use, Proxelle grants you a personal, non-exclusive, non-transferable, limited privilege to use the Service."
                        },
                      @{@"title":@"Account Registration",
                        @"content":@"In order to use the Services, you may be required to sign up for an account. To sign up for an account, you must provide a username and password. You may not sign up using a name that you do not have the right to use, or another person's name with the intent to impersonate that person."
                        },
                      @{@"title":@"Representations and Warranties",
                        @"content":@"You represent and warrant that you are of legal age to enter into a binding contract. If not, you represent and warrant that you have acquired parental consent and that they have read and agreed to these Terms on your behalf. If you're using the Services on behalf of an organization or entity, you represent and warrant that you are authorized to agree to these Terms on their behalf and bind them to these Terms. You may only use the Services for your personal, non-commercial use. Your use must comply with all laws that apply to you. You may not use these Services if applicable laws prohibit such use."
                        },
                      @{@"title":@"Restrictions on Use",
                        @"content":@"During your usage of the Services, you may create connections between our hardware devices, third-party hardware devices, our Services, and/or third-party services. You agree that you will not connect to the Services any hardware devices or third-party services in a manner that could be dangerous to any person(s), or which could cause damage to or loss of any property. Your use of the Services is subject to the following additional restrictions:\n\nYou may not use the Services or interact with the Services in a manner that:\n\n1. Infringes or violates the intellectual property rights or any other rights of anyone else;\n\n2. Violates any law or regulation;\n\n3. Is harmful, fraudulent, deceptive, threatening, harassing, defamatory, obscene, or otherwise objectionable;\n\n4. Jeopardizes the security of your account or anyone else's;\n\n5. Attempts, in any manner, to obtain the password, account, or other security information from any other user;\n\n6. Violates the security of any computer network, or cracks any passwords or security encryption codes;\n\n7. Runs any form of auto-responder or \"spam\" on the Services, or that otherwise interfere with the proper working of the Services (including by placing an unreasonable load on the Services' infrastructure);\n\n8. \"Crawls,\" \"scrapes,\" or \"spiders\" any page or portion of the Services (through use of manual or automated means);\n\n9. Copies or stores any significant portion of the Content (as defined below);\n\n10. Decompiles, reverse engineers, or otherwise attempts to obtain the source code of the Services."
                        },
                      @{@"title":@"Content on the Services",
                        @"content":@"\"Content\" is all the of the information collected during your use of the Services. It includes information provided by you, by other users, by hardware devices connected to the Services, and by third-party devices and services connected to the Services. It also includes any information we provide into the Services, as well as information derived from or aggregated from any and all information provided to the Services."
                        },
                      @{@"title":@"Third-Party Services",
                        @"content":@"You accept that Proxelle is not responsible for the risks you take associated with links or connections to third-party applications or services. You understand that such third-party services may or may not carry their own terms, conditions, privacy policies or other policies that may or may not be related to these Services. We encourage you to be aware of such agreements when you connect third-party services to these Services. We cannot and do not have control over, nor do we assume any responsibility or risk for content, accuracy, practices, opinions, or policies of any third-party websites, applications, or services that you may be exposed to when you interact with the Services. Your interactions with third-party organizations and/or individuals found on or through the Services are solely between you and such organizations and/or individuals found on or through the Services are solely between you and such organizations and/or individuals. You agree that we shall not be responsible for any liability for any loss or damage associated with any such interaction."
                        },
                      @{@"title":@"Termination",
                        @"content":@"You are free to stop using the Services at any time. You understand and agree that we may or may not delete your Content in the event that you stop using the Services. Account termination may result in destruction of any Personal Submissions and/or Device Submissions associated with your account; however, you understand and agree that we may retain copies of such Content indefinitely. In the event that we elect to terminate your account, we will try to provide advance notice to you prior to termination so that you are able to retrieve any important Content stored in your account. You understand and agree that we may provide no advanced notice for any reason, but usually because it would be impractical, illegal, not in the interest of someone's safety or security, or otherwise harmful to the rights or property of Whatie.\n\nIf any provision of this agreement is found to be unenforceable or invalid, that provision will be limited or eliminated, to the minimum extent necessary, so that these Terms shall otherwise remain in full force and effect and enforceable."
                        },
                      @{@"title":@"Additional Terms and Conditions",
                        @"content":@"These Terms apply to your use of all the Services including applications available via both the Apple, Inc. (\"Apple\") App Store (the \"Application\") and the Google, Inc. (\"Google\") Play Store (also the \"Application\"), but the following additional terms also apply to the Application:\n\n1. The Application is licensed to you on a limited, non-exclusive, non-transferable, non-sublicensable basis, solely to be used in connection with the Services for your private, personal, noncommercial use, subject to all the Terms as they are applicable to the Services;\n\n2. Both you and Whatie acknowledge that the Terms are concluded between you and Whatie only, and not with Apple or Google, and that Apple or Google is not responsible for the Application or the Content;\n\n3. You will only use the Application in connection with an Apple or Google device that you own or control;\n\n4. You acknowledge that Apple or Google has no obligation whatsoever to furnish any maintenance and support services with respect to the Application;\n\n5. In the event of any failure of the Application to conform to any applicable warranty, including those implied by the law, you may notify Apple or Google of such failure; upon notification, Apple's or Google's sole warranty obligation to you will be to refund you the purchase price, if any, of the Application;\n\n6. You acknowledge and agree that Whatie, and neither Apple nor Google, is responsible for addressing any claims you or any third-party may have in relation to the Application;\n\n7. You acknowledge and agree that, in the event of any third-party claim that the Application or your possession and use of the Application infringes that third-party's intellectual property rights, Whatie, and neither Apple nor Google, will be responsible for the investigation;\n\n8. Both you and Whatie acknowledge and agree that, in your use of the Application, you will comply with any applicable third-party terms of agreement which may affect or be affected by such use;\n\n9. Both you and Whatie acknowledge and agree that Apple and Apple's subsidiaries as well as Google and Google's subsidiaries are third-party beneficiaries of this Agreement, and that upon your acceptance of this Agreement, Apple or Google will have the right (and will be deemed to have accepted the right) to enforce this Agreement against you as third-party beneficiary hereof."
                        },
                      @{@"title":@"Risk of Loss; Insurance",
                        @"content":@"You acknowledge and agree that your use of the services (including, without limitation, using the services to secure or otherwise control access to any real or personal property) is solely at your own risk, and that you accept responsibility for all losses, damages, and expenses arising out of such use. You are responsible for maintaining insurance covering all loss, damage, or expense, whether for property damage, or expense, whether for property damage, personal injury (including death), economic losses, or any other form of loss, damage, or expense arising out of or from (i) these terms, or (ii) the services."
                        },
                      @{@"title":@"Assignment",
                        @"content":@"You may not assign, delegate, or transfer these Terms or your rights or obligations hereunder, or your Services account, in any way (by operation of law or otherwise) without Proxelle's prior written consent. We may transfer, assign, or delegate these Terms and our rights and obligations without consent."
                        },
                      ];
        }
            break;
        case Ozwi:
        {
            terms = @[@{@"title":@"Terms of Use",
                        @"content":@"Thank you for building your smart home with Ozwi Home!\n\nThese Terms and Conditions of Use (the \"Terms of Use\") apply to the eHome and all associated sites linked to www.whatie.com by Whatie. BY USING THE EHOME, YOU AGREE TO THESE TERMS OF USE; IF YOU DO NOT AGREE, DO NOT USE THE APP."
                        },
                      @{@"title":@"Modification to Terms",
                        @"content":@"Whatie reserves the right, at its sole discretion, to change, modify, add or remove portions of these Terms of Use, at any time. In the event that we need to change the Services, we will place a notice in the Terms and may also send you an email. It is your responsibility to check these Terms of Use periodically for changes. Your continued use of the Service following the posting of changes will mean that you accept and agree to the changes. As long as you comply with these Terms of Use, Whatie grants you a personal, non-exclusive, non-transferable, limited privilege to use the Service."
                        },
                      @{@"title":@"Account Registration",
                        @"content":@"In order to use the Services, you may be required to sign up for an account. To sign up for an account, you must provide a username and password. You may not sign up using a name that you do not have the right to use, or another person's name with the intent to impersonate that person."
                        },
                      @{@"title":@"Representations and Warranties",
                        @"content":@"You represent and warrant that you are of legal age to enter into a binding contract. If not, you represent and warrant that you have acquired parental consent and that they have read and agreed to these Terms on your behalf. If you're using the Services on behalf of an organization or entity, you represent and warrant that you are authorized to agree to these Terms on their behalf and bind them to these Terms. You may only use the Services for your personal, non-commercial use. Your use must comply with all laws that apply to you. You may not use these Services if applicable laws prohibit such use."
                        },
                      @{@"title":@"Restrictions on Use",
                        @"content":@"During your usage of the Services, you may create connections between our hardware devices, third-party hardware devices, our Services, and/or third-party services. You agree that you will not connect to the Services any hardware devices or third-party services in a manner that could be dangerous to any person(s), or which could cause damage to or loss of any property. Your use of the Services is subject to the following additional restrictions:\n\nYou may not use the Services or interact with the Services in a manner that:\n\n1. Infringes or violates the intellectual property rights or any other rights of anyone else;\n\n2. Violates any law or regulation;\n\n3. Is harmful, fraudulent, deceptive, threatening, harassing, defamatory, obscene, or otherwise objectionable;\n\n4. Jeopardizes the security of your account or anyone else's;\n\n5. Attempts, in any manner, to obtain the password, account, or other security information from any other user;\n\n6. Violates the security of any computer network, or cracks any passwords or security encryption codes;\n\n7. Runs any form of auto-responder or \"spam\" on the Services, or that otherwise interfere with the proper working of the Services (including by placing an unreasonable load on the Services' infrastructure);\n\n8. \"Crawls,\" \"scrapes,\" or \"spiders\" any page or portion of the Services (through use of manual or automated means);\n\n9. Copies or stores any significant portion of the Content (as defined below);\n\n10. Decompiles, reverse engineers, or otherwise attempts to obtain the source code of the Services."
                        },
                      @{@"title":@"Content on the Services",
                        @"content":@"\"Content\" is all the of the information collected during your use of the Services. It includes information provided by you, by other users, by hardware devices connected to the Services, and by third-party devices and services connected to the Services. It also includes any information we provide into the Services, as well as information derived from or aggregated from any and all information provided to the Services."
                        },
                      @{@"title":@"Third-Party Services",
                        @"content":@"You accept that Whatie is not responsible for the risks you take associated with links or connections to third-party applications or services. You understand that such third-party services may or may not carry their own terms, conditions, privacy policies or other policies that may or may not be related to these Services. We encourage you to be aware of such agreements when you connect third-party services to these Services. We cannot and do not have control over, nor do we assume any responsibility or risk for content, accuracy, practices, opinions, or policies of any third-party websites, applications, or services that you may be exposed to when you interact with the Services. Your interactions with third-party organizations and/or individuals found on or through the Services are solely between you and such organizations and/or individuals found on or through the Services are solely between you and such organizations and/or individuals. You agree that we shall not be responsible for any liability for any loss or damage associated with any such interaction."
                        },
                      @{@"title":@"Termination",
                        @"content":@"You are free to stop using the Services at any time. You understand and agree that we may or may not delete your Content in the event that you stop using the Services. Account termination may result in destruction of any Personal Submissions and/or Device Submissions associated with your account; however, you understand and agree that we may retain copies of such Content indefinitely. In the event that we elect to terminate your account, we will try to provide advance notice to you prior to termination so that you are able to retrieve any important Content stored in your account. You understand and agree that we may provide no advanced notice for any reason, but usually because it would be impractical, illegal, not in the interest of someone's safety or security, or otherwise harmful to the rights or property of Whatie.\n\nIf any provision of this agreement is found to be unenforceable or invalid, that provision will be limited or eliminated, to the minimum extent necessary, so that these Terms shall otherwise remain in full force and effect and enforceable."
                        },
                      @{@"title":@"Additional Terms and Conditions",
                        @"content":@"These Terms apply to your use of all the Services including applications available via both the Apple, Inc. (\"Apple\") App Store (the \"Application\") and the Google, Inc. (\"Google\") Play Store (also the \"Application\"), but the following additional terms also apply to the Application:\n\n1. The Application is licensed to you on a limited, non-exclusive, non-transferable, non-sublicensable basis, solely to be used in connection with the Services for your private, personal, noncommercial use, subject to all the Terms as they are applicable to the Services;\n\n2. Both you and Whatie acknowledge that the Terms are concluded between you and Whatie only, and not with Apple or Google, and that Apple or Google is not responsible for the Application or the Content;\n\n3. You will only use the Application in connection with an Apple or Google device that you own or control;\n\n4. You acknowledge that Apple or Google has no obligation whatsoever to furnish any maintenance and support services with respect to the Application;\n\n5. In the event of any failure of the Application to conform to any applicable warranty, including those implied by the law, you may notify Apple or Google of such failure; upon notification, Apple's or Google's sole warranty obligation to you will be to refund you the purchase price, if any, of the Application;\n\n6. You acknowledge and agree that Whatie, and neither Apple nor Google, is responsible for addressing any claims you or any third-party may have in relation to the Application;\n\n7. You acknowledge and agree that, in the event of any third-party claim that the Application or your possession and use of the Application infringes that third-party's intellectual property rights, Whatie, and neither Apple nor Google, will be responsible for the investigation;\n\n8. Both you and Whatie acknowledge and agree that, in your use of the Application, you will comply with any applicable third-party terms of agreement which may affect or be affected by such use;\n\n9. Both you and Whatie acknowledge and agree that Apple and Apple's subsidiaries as well as Google and Google's subsidiaries are third-party beneficiaries of this Agreement, and that upon your acceptance of this Agreement, Apple or Google will have the right (and will be deemed to have accepted the right) to enforce this Agreement against you as third-party beneficiary hereof."
                        },
                      @{@"title":@"Risk of Loss; Insurance",
                        @"content":@"You acknowledge and agree that your use of the services (including, without limitation, using the services to secure or otherwise control access to any real or personal property) is solely at your own risk, and that you accept responsibility for all losses, damages, and expenses arising out of such use. You are responsible for maintaining insurance covering all loss, damage, or expense, whether for property damage, or expense, whether for property damage, personal injury (including death), economic losses, or any other form of loss, damage, or expense arising out of or from (i) these terms, or (ii) the services."
                        },
                      @{@"title":@"Assignment",
                        @"content":@"You may not assign, delegate, or transfer these Terms or your rights or obligations hereunder, or your Services account, in any way (by operation of law or otherwise) without Whatie's prior written consent. We may transfer, assign, or delegate these Terms and our rights and obligations without consent."
                        },
                      ];
        }
            break;
            
        default:
            break;
    }
    
    return terms;

}




@end
