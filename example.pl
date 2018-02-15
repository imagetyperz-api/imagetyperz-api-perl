#!/bin/perl

use warnings;
use strict;
use File::Basename;
use File::Spec;
# set library path
use lib File::Spec->catfile( dirname (__FILE__), 'lib' );
use ImageTyperzAPI;

sub test_api
{	
	# access token, get from: http://www.imagetyperz.com/Forms/ClientHome.aspx
	my $access_token = 'your_access_token';
	
	# set your own username and password, legacy way, use access_token instead
	# ----------------------------------
	#my $username = 'your_username';
	#my $password = 'your_password';

	# recaptcha settings
	#my $page_url = 'your_page_url';
	#my $sitekey = 'your_site_key';

	# check account balance
	# ----------------------
	printf 'Balance token: %s\n', ImageTyperzAPI::account_balance_token($access_token);
	#printf 'Balance legacy: %s\n', ImageTyperzAPI::account_balance_legacy($username, $password);
	
	# solve normal captcha
	# --------------------
	my $captcha_text = ImageTyperzAPI::solve_captcha_token($access_token, 'captcha.jpg', '1');	
	printf 'Captcha text: %s\n', $captcha_text;
	# ==============================================================================
	# solve recaptcha
	# -------------------------
	# submit
	# -------
	my $captcha_id = ImageTyperzAPI::submit_recaptcha_token($access_token, $page_url, $sitekey);
	#my $captcha_id = ImageTyperzAPI::submit_recaptcha_legacy($username, $password, $page_url, $sitekey);
	
	# retrieve
	# -------
	while(ImageTyperzAPI::in_progress_token($access_token, $captcha_id))	# while in progress
	#while(ImageTyperzAPI::in_progress_legacy($username, $password, $captcha_id))	# while in progress
	{
		sleep(10);		# sleep for 10 seconds
	}
	printf 'Recaptcha response token: %s\n', ImageTyperzAPI::retrieve_recaptcha_token($access_token, $captcha_id);
	#printf 'Recaptcha response token: %s\n', ImageTyperzAPI::retrieve_recaptcha_legacy($username, $password, $captcha_id);
		
	# recaptcha
	# ----------
	# my $captcha_id2 = ImageTyperzAPI::submit_recaptcha_legacy($username, $password, $page_url, $sitekey, $ref_id);	# with refid
	# my $captcha_id2 = ImageTyperzAPI::submit_recaptcha_legacy($username, $password, $page_url, $sitekey, $ref_id, 'ip:port');     # http proxy
	# my $captcha_id2 = ImageTyperzAPI::submit_recaptcha_legacy($username, $password, $page_url, $sitekey, $ref_id, 'ip:port:user:pass');	# proxy auth
	# while(ImageTyperzAPI::in_progress_legacy($username, $password, $captcha_id2))	# while in progress
	# {
	# 	sleep(10);		# sleep for 10 seconds
	# }
	# printf 'Recaptcha response legacy: %s\n', ImageTyperzAPI::retrieve_recaptcha_legacy($username, $password, $captcha_id2);
	
	# Other examples
	# ---------------------------------------------------------------------------------------------------------------------------------
	# my $captcha_text = ImageTyperzAPI::solve_captcha_legacy($username, $password, 'captcha.jpg', '1', $ref_id);
	# my $captcha_text = ImageTyperzAPI::solve_captcha_token($access_token, 'captcha.jpg', '1', $ref_id);	# with caseSensitive and affiliate_id
	
	# my $captcha_id = ImageTyperzAPI::submit_recaptcha_token($access_token, $page_url, $sitekey, $ref_id);	# with refid
	# my $captcha_id = ImageTyperzAPI::submit_recaptcha_token($access_token, $page_url, $sitekey, $ref_id, 'ip:port');     # http proxy
	# my $captcha_id = ImageTyperzAPI::submit_recaptcha_token($access_token, $page_url, $sitekey, $ref_id, 'ip:port:user:pass');	# proxy auth
	
	# printf 'Set captcha bad response token: %s\n', ImageTyperzAPI::set_captcha_bad_token($access_token, $captcha_id);		# set captcha as bad
	# printf 'Set captcha bad response legacy: %s\n', ImageTyperzAPI::set_captcha_bad_legacy($username, $password, $captcha_id2);		# set captcha as bad, legacy
}

test_api();		# test API

1;
