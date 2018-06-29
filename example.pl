#!/bin/perl

use warnings;
use strict;
use File::Basename;
use File::Spec;
# set library path
use lib File::Spec->catfile(dirname(__FILE__), 'lib');
use ImageTyperzAPI;

sub test_api {
    # access token, get from: http://www.imagetyperz.com/Forms/ClientHome.aspx
    my $access_token = 'access_token_here';

    # set your own username and password, legacy way, use access_token instead
    # ----------------------------------
    #my $username = 'your_username';
    #my $password = 'your_password';

    # check account balance
    # ----------------------
    #printf 'Balance token: %s\n', ImageTyperzAPI::account_balance_token($access_token);
    #printf 'Balance legacy: %s\n', ImageTyperzAPI::account_balance_legacy($username, $password);
    # solve normal captcha
    # --------------------
    #my $captcha_text = ImageTyperzAPI::solve_captcha_token($access_token, 'captcha.jpg', '1');
    #printf 'Captcha text: %s\n', $captcha_text;
    # ==============================================================================
    # solve recaptcha
    # -------------------------
    # submit
    # -------
    my $recaptcha_params = [
        token      => $access_token,
        #username => $username,       # for legacy auth
        #password   => $password,      # for legacy auth

        action     => 'UPLOADCAPTCHA',
        pageurl    => 'page_url_here',
        googlekey  => 'sitekey_here',

        # v3
        # recaptchatype => '3',        # optional, 1 - normal recaptcha, 2 - invisible recaptcha, 3 - v3 recaptcha, default: 1
        # captchaaction => 'homepage', # optional, used in solving v3 recaptcha
        # score => '0.3',              # optional, min score to target when solving v3 recaptcha

        # proxy
        # proxy => '12.34.54.56:123',        # or '123.43.45.65:123:user:password' with auth - optional
        # proxytype => 'HTTP', # if proxy is used, un-comment this as well, only HTTP supported for now

        # other optional parameters
        # useragent => 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0', # optional
        # affiliateid => '12344'    # affiliate id - optional
    ];
    my $captcha_id = ImageTyperzAPI::submit_recaptcha_token($recaptcha_params);
    #my $captcha_id = ImageTyperzAPI::submit_recaptcha_legacy($recaptcha_params);
    printf 'Recaptcha ID: %s', $captcha_id;
    # retrieve
    # -------
    while (ImageTyperzAPI::in_progress_token($access_token, $captcha_id)) # while in progress
    #while(ImageTyperzAPI::in_progress_legacy($username, $password, $captcha_id))	# while in progress
    {
        sleep(10); # sleep for 10 seconds
    }
    printf 'Recaptcha response token: %s\n', ImageTyperzAPI::retrieve_recaptcha_token($access_token, $captcha_id);
    #printf 'Recaptcha response token: %s\n', ImageTyperzAPI::retrieve_recaptcha_legacy($username, $password, $captcha_id);

    # recaptcha
    # ----------
    # while(ImageTyperzAPI::in_progress_legacy($username, $password, $captcha_id2))	# while in progress
    # {
    # 	sleep(10);		# sleep for 10 seconds
    # }
    # printf 'Recaptcha response legacy: %s\n', ImageTyperzAPI::retrieve_recaptcha_legacy($username, $password, $captcha_id2);

    # Other examples
    # ---------------------------------------------------------------------------------------------------------------------------------
    # my $captcha_text = ImageTyperzAPI::solve_captcha_legacy($username, $password, 'captcha.jpg', '1', $ref_id);
    # my $captcha_text = ImageTyperzAPI::solve_captcha_token($access_token, 'captcha.jpg', '1', $ref_id);	# with caseSensitive and affiliate_id

    # method to check if proxy was used, response is json
    # {
    #     "Result": "gresponse from solving, or empty if not solved yet",
    #     "Proxy_client": "proxy submitted by client (if any)",
    #     "Proxy_worker": "proxy used by worker, in case client submitted, and no errors with proxy",
    #     "Proxy_reason": "in case of proxy not working, reason will be found here"
    # }
    #printf 'Was proxy used: %s\n', ImageTyperzAPI::was_proxy_used_token($access_token, $captcha_id);
    #printf 'Was proxy used: %s\n', ImageTyperzAPI::was_proxy_used_legacy($username, $password, $captcha_id);

    # printf 'Set captcha bad response token: %s\n', ImageTyperzAPI::set_captcha_bad_token($access_token, $captcha_id);		# set captcha as bad
    # printf 'Set captcha bad response legacy: %s\n', ImageTyperzAPI::set_captcha_bad_legacy($username, $password, $captcha_id2);		# set captcha as bad, legacy
}

test_api(); # test API

1;
