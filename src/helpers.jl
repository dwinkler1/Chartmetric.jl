
function hasvalue(response)
    return haskey(response, "obj")
end

"""
    parseresponse(response::HTTP.Messages.Response)

Parses the response from the API to a `Dict`.
"""
function parseresponse(response::HTTP.Messages.Response)
    bod = response.body
    code = response.status
    if code ∉ 200:399
        ret_dict = Dict{String,Any}()
        ret_dict["code"] = code
        ret_dict["url"] = response.request.target
        try
            ret_dict["return"] = JSON.parse(String(bod))
        catch e
            ret_dict["return"] = missing
        end
        return ret_dict
    end
    ret_dict = JSON.parse(String(bod))
    return ret_dict
end

function flattenlists!(responsedict)
    for dict in responsedict["obj"]
        for (key, value) in dict
            dict[key] = typeof(value) <: Array ? join(value, ", ") : value
        end
    end
end

function buildrequesturl(path)
    base = "https://api.chartmetric.com/api/"
    urls = join(path, '/')
    url_req = base * urls
    return url_req
end

# Not exported
function ratelimitprotect(response::HTTP.Messages.Response; verbose=false)
    headers = Dict(response.headers)
    remaining = haskey(headers, "X-RateLimit-Remaining") ? tryparse(Int, headers["X-RateLimit-Remaining"]) : 0
    if isnothing(remaining) || remaining < 1
        resetin = haskey(headers, "X-RateLimit-Reset") ? tryparse(Int, headers["X-RateLimit-Reset"]) - time() : 1
        resetin = isnothing(resetin) ? 1 : resetin
        resetin < 0 && return nothing
        sleepfor = max(0.1, resetin)
        verbose && println("Protecting rate limit")
        sleep((sleepfor + 0.01))
    end
    return nothing
end

function parsecmdate(date::String)
    date_tmp = string(SubString(date, 1:25))
    return parse(Dates.DateTime, date_tmp, Dates.RFC1123Format)
end
