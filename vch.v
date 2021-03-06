module vch

import os
import flag
import net.http
import v.vmod

pub struct Client {
pub:
	api    string = 'http://localhost:8123'
	auth   string
	format string = 'JSONEachRow'
}

pub fn new_client(api string, auth string) Client {
	return Client{
		api: api
		auth: auth
	}
}

fn (d Client) ping() string {
	mut url := '$d.api/ping'
	if utf8_str_len(d.ch_auth) > 8 {
		auth := d.ch_auth.split(':')
		tmp := url.split('://')
		if tmp[1].len > 0 {
			url = url + '&password=' + auth[1]
		}
	}
	resp := http.get(url) or {
		println('failed to fetch data from the server')
		return ''
	}
	return resp.text
}

fn (d Client) exec(query string) string {
	mut url := '$d.api'
	mut q := '$query'

	if utf8_str_len(d.format) > 0 {
		q = q + ' FORMAT ' + d.format
	}
	url = url + '/?query=$q'
	if utf8_str_len(d.ch_auth) > 8 {
		auth := d.ch_auth.split(':')
		tmp := url.split('://')
		if tmp[1].len > 0 {
			url = url + '&password=' + auth[1]
		}
	}

	resp := http.get(url) or {
		println('failed to fetch data from the server')
		return ''
	}
	return resp.text
}
