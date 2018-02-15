imagetyperz-api-perl - Imagetyperz API wrapper
=========================================

imagetyperzapi is a super easy to use bypass captcha API wrapper for 
imagetyperz.com captcha service

## Installation
    
    git clone https://github.com/imagetyperz-api/imagetyperz-api-perl
     

## How to use?

``` perl
use lib File::Spec->catfile( dirname (__FILE__), 'lib' );
use ImageTyperzAPI;
```

There are 2 ways of authenticating with the server. With 
**access_token** or **username and passord**. 
We encourage you to use the token based authentication because it's more 
secure and username & password authentication might be removed at some 
point from the API libraries.

All the methods that end with **_token** will be used for token 
authentication


**Get balance**

``` perl
ImageTyperzAPI::account_balance_token($access_token);     
```

**Submit image captcha**

``` perl
my $captcha_text = ImageTyperzAPI::solve_captcha_token($access_token, 
'captcha.jpg', '1');
```

**Submit recaptcha details**

For recaptcha submission there are two things that are required.
- page_url
- site_key

``` perl
my $captcha_id = ImageTyperzAPI::submit_recaptcha_token($access_token, 
$page_url, $sitekey);
```
This method returns a captchaID. This ID will be used next, to retrieve 
the g-response, once workers have 
completed the captcha. This takes somewhere between 10-80 seconds.

**Retrieve captcha response**

Once you have the captchaID, you check for it's progress, and later on 
retrieve the gresponse.

The ***in_progress($access_token, $captcha_id)*** method will tell you 
if captcha is still being decoded by workers.
Once it's no longer in progress, you can retrieve the gresponse with 
***retrieve_recaptcha_token($access_token, $captcha_id)***  

``` perl
while(ImageTyperzAPI::in_progress_token($access_token, $captcha_id))
{
    sleep(10);		# sleep for 10 seconds
}

my $gresponse = ImageTyperzAPI::retrieve_recaptcha_token($access_token, 
$captcha_id);
```

## Other methods/variables

**Legacy auth**

The library has 2 ***sets*** of methods. Those that end with **_token** 
use token auth, and uses the 1st given parameter as token. Methods that 
end with **_legacy** take 2 parameters, username and password, instead 
of access key.

Getting balance with token

```perl
ImageTyperzAPI::account_balance_token($access_token);
```

and here it's the same with legacy/username & password authentication
```perl
ImageTyperzAPI::account_balance_legacy($username, $password);
```

**Affiliate id**

For submitting recaptcha with affiliate ID, set it as the next parameter 
after sitekey.

``` perl
ImageTyperzAPI::submit_recaptcha_token($token, $page_url, $sitekey, 
$aff_id);
```

Affiliate ID can be set for normal captcha solving as well

**Case sensitive**

Regular captcha takes a case-sensitive argument, after the image 
parameter, which tells the server if captcha is case sensitive or not. 1 
means sensitive.
``` perl
ImageTyperzAPI::solve_captcha_token($access_token, 'captcha.jpg', '1');
```

There's a 4th parameter which can be given here, which is the affiliate 
id, after caseSensitive.

**Set proxy for recaptcha submission**

Recaptcha solving can be made through a proxy. In order for this to 
happen, submit a proxy parameter to the submit_recaptcha_token or 
submit_recaptcha_legacy methods
``` perl
ImageTyperzAPI::submit_recaptcha_legacy($username, $password, $page_url, 
$sitekey, $ref_id, 'ip:port');
```
**Proxy with authentication is also supported**
``` perl
ImageTyperzAPI::submit_recaptcha_legacy($username, $password, $page_url, 
$sitekey, $ref_id, 'ip:port:user:pass');
```
We currently support HTTP proxies.

**Set captcha bad**

When a captcha was solved wrong by our workers, you can notify the 
server with it's ID,
so we know something went wrong.

``` perl
ImageTyperzAPI::set_captcha_bad_token($access_token, $captcha_id);
```

## Examples
Check example.pl

## License
API library is licensed under the MIT License

## More information
More details about the server-side API can be found 
[here](http://imagetyperz.com)

