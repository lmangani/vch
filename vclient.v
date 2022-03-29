module main

import os
import flag
import time
import net.http
import v.vmod

fn fetch_logs(api string, query string, ch_auth string, limit int, format string) {
	mut url := '$api'
	mut q := '$query'

	if utf8_str_len(format) > 8 {
		q = q + ' FORMAT ' + format
	}
	url = url + '/?query=$q'
	println(url)
	if utf8_str_len(ch_auth) > 8 {
		auth := ch_auth.split(':')
		tmp := url.split('://')
		if tmp[1].len > 0 {
			url = url + '&password=' + auth[1]
		}
	}

	/*
	config := http.FetchConfig{
		user_agent: 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0'
	}

	eprintln('trying $url')
	resp := http.fetch(http.FetchConfig{ ...config, url: url }) or {
		println('failed to fetch data from the server')
		return
	}
	eprintln('$resp')
	*/

	gresp := http.get(url) or {
		println('failed to fetch data from the server')
		return
	}
	eprintln('$gresp.text')
}

fn set_value(s string) ?string {
	if s != '' {
		return s
	}
	return none
}

fn now(diff int) string {
	ts := time.utc()
	subts := ts.unix_time_milli() - (diff * 1000)
	return '${subts}000000'
}

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	vm := vmod.decode(@VMOD_FILE) or { panic(err.msg) }
	fp.application('$vm.name')
	fp.description('$vm.description')
	fp.version('$vm.version')
	fp.skip_executable()

	env_limit := set_value(os.getenv('CH_LIMIT')) or { '5' }
	ch_limit := fp.int('limit', `l`, env_limit.int(), 'query limit [CH_LIMIT]')

	env_format := set_value(os.getenv('CH_FORMAT')) or { 'JSON' }
	ch_format := fp.string('format', `f`, env_format, 'output format [CH_FORMAT]')

	env_auth := set_value(os.getenv('CH_AUTH')) or { 'default:' }
	ch_auth := fp.string('auth', `x`, env_auth, 'optional username:password [CH_AUTH]')

	env_api := set_value(os.getenv('CH_API')) or { 'http://localhost:8123' }
	ch_api := fp.string('api', `a`, env_api, 'clickhouse HTTP API [CH_API]')

	env_query := set_value(os.getenv('CH_QUERY')) or { '' }
	ch_query := fp.string('query', `q`, env_query, 'clickhouse query [CH_QUERY]')

	fp.finalize() or {
		eprintln(err)
		println(fp.usage())
		return
	}

	// EXECUTE QUERY

	if utf8_str_len(ch_query) > 0 {
		fetch_logs(ch_api, ch_query, ch_auth, ch_limit, ch_format)
		return
	} else {
		println(fp.usage())
		return
	}
}
