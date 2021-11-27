module GoogleTrans
import HTTP
import JSON
export translate

function package_rpc(text::AbstractString, lang_src::String, lang_tgt::String)::String
    parameter = [[text, lang_src, lang_tgt, true], [1]]
    escaped_parameter = JSON.json(parameter)
    rpc = [[["MkEWBc", escaped_parameter, nothing, "generic"]]]
    escaped_rpc = JSON.json(rpc)
    freq = "f.req=" * HTTP.escapeuri(escaped_rpc) * "&"
    return freq
end

function translate(text::AbstractString, lang_tgt = "auto"::String, lang_src = "auto"::String)::String
    headers = Dict("Referer" => "http://translate.google.com", "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Content-type" => "application/x-www-form-urlencoded;charset=utf-8")
    freq = package_rpc(text, lang_src, lang_tgt)
    r = HTTP.request("POST", "https://translate.google.com/_/TranslateWebserverUi/data/batchexecute", headers, freq)
    JSON.parse(JSON.parse(split(String(r.body), '\n')[end])[1][3])[2][1][1][6][1][1]
end

translate(inputstrings::AbstractVector{S}, lang_tgt = "auto", lang_src = "auto") where {S<:AbstractString} = translate.(inputstrings, lang_tgt, lang_src)

end
