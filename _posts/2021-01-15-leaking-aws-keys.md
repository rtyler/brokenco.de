---
layout: post
title: "Intentionally leaking AWS keys"
tags:
- security
- github
- aws
---

"Never check secrets into source control" is one of those _rules_ that are 100%
correct, until it's not. There are no universal laws in software, and recently
I had a reason to break this one. I checked AWS keys into a Git repository. I
then pushed those commits to a _public_ repository on GitHub. I did this
**intentionally**, and lived to tell the tale. You almost certainly should
never do this, so I thought I would share what happens when you do.

I can imagine you thinking: "this guy posted his AWS credentials on purpose? He
must be an idiot." I don't disagree with your conclusion, but just let me
explain!

My use-case is pretty simple: the
[delta-rs](https://github.com/delta-io/delta-rs) project needed a real S3
bucket to do some integration testing. I decided to set up a real S3 bucket for
our (read-only) integration tests. Fortunately our tests just needed to
retrieve objects from a bucket to confirm that an S3 bucket is presenting
itself as a Delta table properly. I would have _never_ done this if we needed
"write" operations on the bucket.


## Preparing

AWS has an integral access control framework called IAM, not to be confused
with an anagram of "AMI" which [Corey Quinn](https://twitter.com/QuinnyPig) can
help you learn how to pronounce. IAM allows crafting policies and roles for
just about everything in AWS a dozen or more different ways. It slices, it
dices, it keeps your buckets safe. It is also configured with JSON, which is
awful, but I'll have to save those rantings for another blog post. Anyways,
here's the read-only policy that I set up for the bucket:


```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetLifecycleConfiguration",
                "s3:GetBucketTagging",
                "s3:GetInventoryConfiguration",
                "s3:GetObjectVersionTagging",
                "s3:ListBucketVersions",
                "s3:GetBucketLogging",
                "s3:ListBucket",
                "s3:GetAccelerateConfiguration",
                "s3:GetBucketPolicy",
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectAcl",
                "s3:GetEncryptionConfiguration",
                "s3:GetBucketObjectLockConfiguration",
                "s3:GetBucketRequestPayment",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetMetricsConfiguration",
                "s3:GetBucketOwnershipControls",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetBucketPolicyStatus",
                "s3:ListBucketMultipartUploads",
                "s3:GetObjectRetention",
                "s3:GetBucketWebsite",
                "s3:GetBucketVersioning",
                "s3:GetBucketAcl",
                "s3:GetObjectLegalHold",
                "s3:GetBucketNotification",
                "s3:GetReplicationConfiguration",
                "s3:ListMultipartUploadParts",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:GetBucketCORS",
                "s3:GetAnalyticsConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetBucketLocation",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::deltars",
                "arn:aws:s3:::deltars/*"
            ]
        }
    ]
}
```

I also set up an [AWS
Budget](https://aws.amazon.com/aws-cost-management/aws-budgets/) to alert me
should this start to ever cost real money. My currently monthly costs in this
AWS account are almost $1.50, so my budget is set such that if/when this
starts costing me more than a couple of dollars a month, AWS will email me so I
can figure out what to do in order to save my snapple money.

Finally, I created an IAM user for the integration tests. This IAM user has a
single IAM policy attached to it, listed out above. I then took the AWS access
key and secret key ID for the IAM user and checked those into Git.

---

**2021-01-19 update:** An anonymous reader points out:

_Certain AWS APIs cannot be disabled via IAM, [including
`sts:GetCallerIdentify`](https://docs.aws.amazon.com/STS/latest/APIReference/API_GetCallerIdentity.html)
which in turn allows anyone with the public credentials to run the AWS
equivalent of `whoami`:_

    % AWS_PROFILE=rtyler aws sts get-caller-identity
    {
        "UserId": "AIDAX7EGEQ7F24XVIBAAL",
        "Account": "547889645515",
        "Arn": "arn:aws:iam::547889645515:user/deltars-ro"
    }

_AWS account numbers and IAM user ARNs are not especially privileged but be
aware that publishing access keys has a side effect of disclosing those too._

---



## Boom goes the dynamite

After preparing the integration tests, I pushed [my pull
request](https://github.com/delta-io/delta-rs/pull/63) at **13:05 PST**. When
pushing code to GitHub, anything that looks like an AWS access key is
immediately identified by robots around the world, most of them
malicious in intent, but a few designed to help developers like me who make silly mistakes.

At **13:05:36 PST**, an AWS Support Case was opened in my account:

> Dear AWS customer,
>
> We have become aware that the AWS Access Key AKIAX7EGEQ7FT6CLQGWH, belonging to IAM User deltars-ro, along with the corresponding Secret Key is publicly available online at https://github.com/rtyler/delta.rs/blob/b3581ee06eee26d971bd3b76bb788c85ecf0c6c0/rust/tests/s3_test.rs .
>
> Your security is important to us and this exposure of your account’s IAM credentials poses a security risk to your AWS account, could lead to excessive charges from unauthorized activity, and violates the AWS Customer Agreement or other agreement with us governing your use of our Services.
>
> To protect your account from excessive charges and unauthorized activity, we have applied the "AWSCompromisedKeyQuarantine" AWS Managed Policy ("Quarantine Policy") to the IAM User listed above. The Quarantine Policy applied to the User protects your account by limiting permissions for high risk AWS services.
> You can view the policy by going here: https://console.aws.amazon.com/iam/home#policies/arn:aws:iam::aws:policy/AWSCompromisedKeyQuarantine$jsonEditor?section=permissions .
>
> For your security, DO NOT remove the Quarantine Policy before following the instructions below. In cases where the Quarantine Policy is causing production issues you may detach the policy from the user. NOTE: Only users with admin privileges or with access to iam:DetachUserPolicy may remove the policy. For instructions on how to remove managed policies go here: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html#remove-policies-console . In the event of the unauthorized use of your AWS account, we may, at our sole discretion, provide you with concessions. However, a failure to follow the instructions below may jeopardize your ability to receive a concession.
>
> If you believe you've received this note in error, please contact us immediately via the support case.
>
> PLEASE FOLLOW THE INSTRUCTIONS BELOW TO SECURE YOUR ACCOUNT:
>
> Step 1: Delete or rotate the exposed AWS Access Key AKIAX7EGEQ7FT6CLQGWH. To delete IAM User Keys go to your AWS Management Console here: https://console.aws.amazon.com/iam/home#users . To delete Root User Keys go here: https://console.aws.amazon.com/iam/home#security_credential .
>
> If your application uses the exposed Access Key, you need to replace the Key. To replace the Key, first create a second Key (at that point both Keys will be active) and then modify your application to use the new Key.
> Then disable (but do not delete) the exposed Key by clicking on the “Make inactive” option in the console. If there are any problems with your application, you can reactivate the exposed Key. When your application is fully functional using the new Key, please delete the exposed Key.
>
> NOTE: Only rotating or deleting the exposed Key may not be sufficient to protect your account, see Step 2.
>
> Step 2: Check your CloudTrail log for unsanctioned activity such as the creation of unauthorized IAM users, policies, roles or temporary security credentials. To secure your account please delete any unauthorized IAM users, roles and policies, and revoke any temporary credentials.
>
> To delete unauthorized IAM User, navigate to https://console.aws.amazon.com/iam/home#users . To delete unauthorized policies go here: https://console.aws.amazon.com/iam/home#/policies . To delete unauthorized roles go here: https://console.aws.amazon.com/iam/home#/roles  .
>
> Unauthorized temporary credentials may have been created for the IAM User deltars-ro with the exposed AWS Access Key AKIAX7EGEQ7FT6CLQGWH. You can revoke temporary credentials by following instructions outlined here: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_control-access_disable-perms.html#denying-access-to-credentials-by-issue-time . Temporary credentials can also be revoked by deleting the IAM User. NOTE: Deleting IAM Users may impact production workloads and should be done with care.
>
> Step 3: Check your CloudTrail log to review your AWS account for any unauthorized AWS usage, such as unauthorized EC2 instances, Lambda functions or EC2 Spot bids. You can also check usage by logging into your AWS Management Console and reviewing each service page. The "Bills" page in the Billing console can also be checked for unexpected usage. https://console.aws.amazon.com/billing/home#/bill
>
> Please keep in mind that unauthorized usage can occur in any region and that your console may show you only one region at a time. To switch between regions, you can use the dropdown in the top-right corner of the console screen.
>
> Please take steps to prevent any new credentials from being publicly exposed. See Best Practices of Managing your Access Keys at http://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html .
>
> WE RECOMMEND THAT YOU ENABLE AMAZON GUARDDUTY:
>
> Amazon GuardDuty is an AWS threat detection service that helps you continuously monitor and protect your AWS accounts and workloads. Enabling Amazon GuardDuty on your accounts gives you further visibility into malicious or unauthorized activity, alerting you to take action in order to reduce the risk of harm. To learn more, visit: https://aws.amazon.com/guardduty .
>
> If you have any questions, you can contact us by accessing the newly created Support Case in your account’s Support Center. If you do not see a new case, you can create a case from the Support Center here: https://console.aws.amazon.com/support/home?#/
>
> Thank you for your immediate attention to this matter.


I *also* got emails from two third party services
[GitGuardian](https://gitguardian.com) at **13:09 PST** and
[leakd.io](https://leakd.io) at **14:56 PST**. Nice try folks, but AWS was
already on top of it within literal seconds of my git push.

I ignored the third party services and responded to the AWS Support Case to let
them know that my disclosure was in fact intentional. The support person surely
rolled their eyes before reminding me that I would be responsible for charges
on the account and still recommended that I:

* Change the password for the root account.
* Delete and rotate all access keys.
* Check for possible unauthorized usage.

---

Normally this story doesn't end well. I did this on purpose and planned
accordingly. There is one incidence of leaking AWS keys on GitHub which I personally know the details of (friend of a friend, I swear!).
An errant `git add`
resulted in a local credentials file being pushed to a personal, but public
repository. Because the email account linked to the AWS account was not
regularly checked, the key was used abusively to rack up a few hundred dollars
on an AWS bill before the keys were revoked.

If you add anything that looks like AWS keys to a public repository, website,
or really anything on the internet, malicious actors will download the keys and
try to launch services in your AWS account. Typically cryptocurrency miners or
spam gateways, anything that costs a lot of money which they're happy you've
volunteered to pay for.

Don't check your AWS credentials into GitHub!

But if you must, do it safely :)
