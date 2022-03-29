module main

import os
import flag
//import term
import time
import net.http
import v.vmod

pub struct Client {
pub:
	api string = "http://localhost:8123"
	auth string
	format string = "JSONEachRow"
}

pub fn new_client(api string, auth string) Client {
    return Client{
        api: api
        auth: auth
    }
}

fn (d Client) exec(query string, ch_auth string) string {

	mut url := '$d.api'
	mut q := '$query'

	if utf8_str_len(d.format) > 0 {
		q = q + ' FORMAT '+d.format
	}
	url = url + '/?query=$q'
	println(url)
	if utf8_str_len(ch_auth) > 8 {
		auth := ch_auth.split(":")
		tmp := url.split("://")
		if tmp[1].len > 0 {
			url = url + '&password=' + auth[1]
		}
	}

	resp := http.get(url) or {
                println('failed to fetch data from the server')
                return ""
        }
	eprintln('$resp.text')
	return ""
}


fn now(diff int) string {
	ts := time.utc()
	subts := ts.unix_time_milli() - (diff * 1000)
	return '${subts}000000'
}
