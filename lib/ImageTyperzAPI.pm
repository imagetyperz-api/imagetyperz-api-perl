#!/bin/perl

package ImageTyperzAPI;

use warnings;
use strict;
use LWP::UserAgent;
use HTTP::Request::Common;
use MIME::Base64 qw(encode_base64);

# constants
# --------------------------------------------------------------------------------------------
my $CAPTCHA_ENDPOINT = 'http://captchatypers.com/Forms/UploadFileAndGetTextNEW.ashx';
my $RECAPTCHA_SUBMIT_ENDPOINT = 'http://captchatypers.com/captchaapi/UploadRecaptchaV1.ashx';
my $RECAPTCHA_RETRIEVE_ENDPOINT = 'http://captchatypers.com/captchaapi/GetRecaptchaText.ashx';
my $BALANCE_ENDPOINT = 'http://captchatypers.com/Forms/RequestBalance.ashx';
my $BAD_IMAGE_ENDPOINT = 'http://captchatypers.com/Forms/SetBadImage.ashx';

my $CAPTCHA_ENDPOINT_CONTENT_TOKEN = 'http://captchatypers.com/Forms/UploadFileAndGetTextNEWToken.ashx';
my $CAPTCHA_ENDPOINT_URL_TOKEN = 'http://captchatypers.com/Forms/FileUploadAndGetTextCaptchaURLToken.ashx';
my $RECAPTCHA_SUBMIT_ENDPOINT_TOKEN = 'http://captchatypers.com/captchaapi/UploadRecaptchaToken.ashx';
my $RECAPTCHA_RETRIEVE_ENDPOINT_TOKEN = 'http://captchatypers.com/captchaapi/GetRecaptchaTextToken.ashx';
my $BALANCE_ENDPOINT_TOKEN = 'http://captchatypers.com/Forms/RequestBalanceToken.ashx';
my $BAD_IMAGE_ENDPOINT_TOKEN = 'http://captchatypers.com/Forms/SetBadImageToken.ashx';

# ACCESS TOKEN
# --------------
# Solve normal captcha
# --------------------------------------------------
sub solve_captcha_token
{
	my $ref_id = '0';
	my $chkcase = '0';
	
	my $ua = LWP::UserAgent->new();
	if(defined $_[2])		# check if chkcase was given
	{
		$chkcase = $_[2];	# set chkcase
	}
	if(defined $_[3])		# check if ref id was given
	{
		$ref_id = $_[3];	# set ref id
	}

	# read file
    local $/ = undef;
    open FILE, $_[1] or die "Couldn't open file: $!";
    my $string = <FILE>;
    close FILE;

	my $response = $ua->request(POST $CAPTCHA_ENDPOINT_CONTENT_TOKEN, Content => [
				 action => 'UPLOADCAPTCHA',
				 token => $_[0],
				 file => encode_base64($string),
				 chkCase => $chkcase,
				 affiliateid => $ref_id
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
		return replace("Uploading file...", "", $c);
    }
}

# Submit recaptcha
# -------------------------------------------------------------------------------------------------
sub submit_recaptcha_token
{
	my $ua = LWP::UserAgent->new();
	my $proxy = '';
	my $ref_id = '0';
	
	if(defined $_[3])		# check if ref id was given
	{
		$ref_id = $_[3];	# set ref id
	}
	
	if(defined $_[4])		# check if proxy was given
	{
		$proxy = $_[4];	# proxy
	}
	else
	{
		$proxy = ''
	}
	
	my $response = $ua->request(POST $RECAPTCHA_SUBMIT_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => [
				 action => 'UPLOADCAPTCHA',
				 token => $_[0],
				 pageurl =>$_[1],
				 googlekey => $_[2],
				 proxy => $proxy,
				 affiliateid => $ref_id
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return $c;		# return ID
    }
}

# Retrieve recaptcha
# -------------------------------------------------------------------------------------------------
sub retrieve_recaptcha_token
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $RECAPTCHA_RETRIEVE_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => [
				 action => 'GETTEXT',
				 token => $_[0],
				 captchaid => $_[1],
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			if (index($c, 'NOT_DECODED') != -1) {		
				 return $c;		# return NOT_DECODED
			}
			else  {die($c);}	# error, die
		} 
        return $c;		# return ID	
    }
}

# Checks if recaptcha is still in process of solving
sub in_progress_token
{
	my $resp = retrieve_recaptcha_token($_[0], $_[1]);
	if(index($resp, 'NOT_DECODED') == -1)
	{
		return 0;		# does not contain NOT_DECODED, move on
	}
	else
	{
		return 1;		# contains NOT_DECODED, still in progress
	}
}

# Check account balance
# -------------------------------------------------------------------------------------------------
sub account_balance_token
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $BALANCE_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => [
				 action => 'REQUESTBALANCE',
				 token => $_[0],
				 'submit' => 'Submit'
				]);

    if ($response->is_error())
    {
		return $response->status_line;			# return error
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return '$' . $c;		# return balance
    }
}

# Set captcha as BAD
sub set_captcha_bad_token
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $BAD_IMAGE_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => [
				 action => 'SETBADIMAGE',
				 token => $_[0],
				 imageid =>$_[1],
				 submit => "Submissssst"
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
        my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return $c;		
    }
}

# LEGACY WAY
# this might get deprecated, better of using access_token
# --------------------------------------------------------

# Solve normal captcha
# --------------------------------------------------
sub solve_captcha_legacy
{
	my $ref_id = '0';
	my $chkcase = '0';
	
	my $ua = LWP::UserAgent->new();
	if(defined $_[3])		# check if chkcase was given
	{
		$chkcase = $_[3];	# set chkcase
	}
	if(defined $_[4])		# check if ref id was given
	{
		$ref_id = $_[4];	# set ref id
	}

	# read file
    local $/ = undef;
    open FILE, $_[2] or die "Couldn't open file: $!";
    my $string = <FILE>;
    close FILE;

	my $response = $ua->request(POST $CAPTCHA_ENDPOINT, Content => [
				 action => 'UPLOADCAPTCHA',
				 username => $_[0],
				 password => $_[1],
				 file => encode_base64($string),
				 chkCase => $chkcase,
				 affiliateid => $ref_id
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
		return replace("Uploading file...", "", $c);
    }
}

# Submit recaptcha
# -------------------------------------------------------------------------------------------------
sub submit_recaptcha_legacy
{
	my $ua = LWP::UserAgent->new();
	my $proxy = '';
	my $ref_id = '0';
	
	if(defined $_[3])		# check if ref id was given
	{
		$ref_id = $_[3];	# set ref id
	}
	
	if(defined $_[4])		# check if proxy was given
	{
		$proxy = $_[4];	# proxy
	}
	else
	{
		$proxy = ''
	}

	my $response = $ua->request(POST $RECAPTCHA_SUBMIT_ENDPOINT, Content_Type => 'form-data', Content => [
				 action => 'UPLOADCAPTCHA',
				 username => $_[0],
				 password => $_[1],
				 pageurl =>$_[2],
				 googlekey => $_[3],
				 proxy => $proxy,
				 affiliateid => $ref_id
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
        my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return $c;		
    }
}

# Retrieve recaptcha
# -------------------------------------------------------------------------------------------------
sub retrieve_recaptcha_legacy
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $RECAPTCHA_RETRIEVE_ENDPOINT, Content_Type => 'form-data', Content => [
				 action => 'GETTEXT',
				 username => $_[0],
				 password => $_[1],
				 captchaid => $_[2],
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			if (index($c, 'NOT_DECODED') != -1) {		
				 return $c;		# return NOT_DECODED
			}
			else {die($c);}	# error, die
		} 
        return $c;		# return ID	
    }
}

# Checks if recaptcha is still in process of solving
sub in_progress_legacy
{
	my $resp = retrieve_recaptcha_legacy($_[0], $_[1], $_[2]);
	if(index($resp, 'NOT_DECODED') == -1)
	{
		return 0;		# does not contain NOT_DECODED, move on
	}
	else
	{
		return 1;		# contains NOT_DECODED, still in progress
	}
}

# Check account balance
# -------------------------------------------------------------------------------------------------
sub account_balance_legacy
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $BALANCE_ENDPOINT, Content_Type => 'form-data', Content => [
				 action => 'REQUESTBALANCE',
				 username => $_[0],
				 password => $_[1],
				 'submit' => 'Submit'
				]);

    if ($response->is_error())
    {
		return $response->status_line;			# return error
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return '$' . $c;	
    }
}

# Set captcha as BAD
sub set_captcha_bad_legacy
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $BAD_IMAGE_ENDPOINT, Content_Type => 'form-data', Content => [
				 action => 'SETBADIMAGE',
				 username => $_[0],
				 password => $_[1],
				 imageid =>$_[2],
				 submit => "Submissssst"
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
        my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return $c;		
    }
}

# replace string
sub replace {
	  my ($from,$to,$string) = @_;
	  $string =~s/$from/$to/ig;                          #case-insensitive/global (all occurrences)

	  return $string;
}

1;
