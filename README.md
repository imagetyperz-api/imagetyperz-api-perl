imagetyperz-api-perl - Imagetyperz API wrapper
=========================================

imagetyperzapi is a super easy to use bypass captcha API wrapper for 
imagetyperz.com captcha service

## Installation
    
    git clone https://github.com/imagetyperz-api/imagetyperz-api-perl
     

## How to use?

``` perl
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
my $captcha_text = ImageTyperzAPI::solve_captcha_token($access_token, 'captcha.jpg', '1');
```

**Submit recaptcha details**

For recaptcha submission there are two things that are required.
- page_url
- site_key
- type - can be one of this 3 values: `1` - normal, `2` - invisible, `3` - v3 (it's optional, defaults to `1`)
- v3_min_score - minimum score to target for v3 recaptcha `- optional`
- v3_action - action parameter to use for v3 recaptcha `- optional`
- proxy - proxy to use when solving recaptcha, eg. `12.34.56.78:1234` or `12.34.56.78:1234:user:password` `- optional`
- user_agent - useragent to use when solve recaptcha `- optional` 

``` perl
my $recaptcha_params = [
    token      => $access_token,
    #username => $username,       # for legacy auth
    #password   => $password,      # for legacy auth

    action     => 'UPLOADCAPTCHA',
    pageurl    => 'page_url_here',
    googlekey  => 'sitekey_here',

    # v3
    recaptchatype => '3',        # optional, 1 - normal recaptcha, 2 - invisible recaptcha, 3 - v3 recaptcha, default: 1
    captchaaction => 'homepage', # optional, used in solving v3 recaptcha
    score => '0.3',              # optional, min score to target when solving v3 recaptcha

    # proxy
    proxy => '12.34.54.56:123',        # or '123.43.45.65:123:user:password' with auth - optional
    proxytype => 'HTTP', # if proxy is used, un-comment this as well, only HTTP supported for now

    # other optional parameters
    useragent => 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0', # optional
    affiliateid => '12344'    # affiliate id - optional
];
my $captcha_id = ImageTyperzAPI::submit_recaptcha_token($recaptcha_params);
```
This method returns a captchaID. This ID will be used next, to retrieve the g-response, once workers have 
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

my $gresponse = ImageTyperzAPI::retrieve_recaptcha_token($access_token, $captcha_id);
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
ImageTyperzAPI::submit_recaptcha_token($token, $page_url, $sitekey, $aff_id);
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


**Get details of proxy for recaptcha**

In case you submitted the recaptcha with proxy, you can check the status of the proxy, if it was used or not,
and if not, what the reason was with the following:

``` perl
printf 'Was proxy used: %s\n', ImageTyperzAPI::was_proxy_used_token($access_token, $captcha_id);
```

The response is in JSON and looks like this:
```json
{
    "Result": "gresponse from solving, or empty if not solved yet",
    "Proxy_client": "proxy submitted by client (if any)",
    "Proxy_worker": "proxy used by worker, in case client submitted, and no errors with proxy",
    "Proxy_reason": "in case of proxy not working, reason will be found here"
}
```

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
More details about the server-side API can be found [here](http://imagetyperz.com)


<sup><sub>captcha, bypasscaptcha, decaptcher, decaptcha, 2captcha, deathbycaptcha, anticaptcha, 
bypassrecaptchav2, bypassnocaptcharecaptcha, bypassinvisiblerecaptcha, captchaservicesforrecaptchav2, 
recaptchav2captchasolver, googlerecaptchasolver, recaptchasolverpython, recaptchabypassscript</sup></sub>

