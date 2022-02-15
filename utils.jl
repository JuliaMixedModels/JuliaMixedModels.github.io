function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

# from https://raw.githubusercontent.com/tlienart/tlienart.github.io/master/utils.jl
using Dates

const FIRST_YEAR = 2015

function hfun_posts()
    curyear = year(Dates.today())
    io = IOBuffer()
    for year in curyear:-1:FIRST_YEAR
        ys = "$year"
        isdir(joinpath("posts", ys)) || continue
        write(io, "\n\n### $year\n\n")
        write(io, "@@list,mb-5\n")
        for month in 12:-1:1
            ms = "0"^(month < 10) * "$month"
            base = joinpath("posts", ys, ms)
            isdir(base) || continue
            posts = filter!(p -> endswith(p, ".md"), readdir(base))
            days  = zeros(Int, length(posts))
            lines = Vector{String}(undef, length(posts))
            for (i, post) in enumerate(posts)
                ps  = splitext(post)[1]
                url = "/posts/$ys/$ms/$ps/"
                surl = strip(url, '/')
                title = pagevar(surl, :title)
                days[i] = parse(Int, first(ps, 2))
                pubdate = Dates.format(
                    Date(year, month, days[i]), "U d")

                tmp = "* ~~~<span class=\"post-date\">$pubdate</span><a href=\"$url\">$title</a>"
                descr = pagevar(surl, :descr)
                if descr !== nothing
                    tmp *= ": <span class=\"post-descr\">$descr</span>"
                end
                lines[i] = tmp * "~~~\n"
            end
            # sort by day
            foreach(line -> write(io, line), lines[sortperm(days, rev=true)])
        end
        write(io, "@@\n")
    end
    return Franklin.fd2html(String(take!(io)), internal=true)
end

@delay function hfun_list_tags()
    tagpages = globvar("fd_tag_pages")
    if tagpages === nothing
        return ""
    end
    tags = tagpages |> keys |> collect |> sort
    tags_count = [length(tagpages[t]) for t in tags]
    io = IOBuffer()
    for (t, c) in zip(tags, tags_count)
        write(io, """
            <nobr>
              <a href=\"/tag/$t/\" class=\"tag-link\">$(replace(t, "_" => " "))</a>
              <span class="tag-count"> ($c)</span>
            </nobr>
            """)
    end
    return String(take!(io))
end

# doesn't need to be delayed because it's generated at tag generation, after everything else
function hfun_tag_list()
    tag = locvar(:fd_tag)::String
    items = Dict{Date,String}()
    for rpath in globvar("fd_tag_pages")[tag]
        title = pagevar(rpath, "title")
        url = Franklin.get_url(rpath)
        surl = strip(url, '/')

        ys, ms, ps = split(surl, '/')[end-2:end]
        date = Date(parse(Int, ys), parse(Int, ms), parse(Int, first(ps, 2)))
        date_str = Dates.format(date, "U d, Y")

        tmp = "* ~~~<span class=\"post-date tag\">$date_str</span><nobr><a href=\"$url\">$title</a></nobr>"
        descr = pagevar(rpath, :descr)
        if descr !== nothing
            tmp *= ": <span class=\"post-descr\">$descr</span>"
        end
        tmp *= "~~~\n"
        items[date] = tmp
    end
    sorted_dates = sort!(items |> keys |> collect, rev=true)
    io = IOBuffer()
    write(io, "@@posts-container,mx-auto,px-3,py-5,list,mb-5\n")
    for date in sorted_dates
        write(io, items[date])
    end
    write(io, "@@")
    return Franklin.fd2html(String(take!(io)), internal=true)
end

function hfun_current_tag()
    return replace(locvar("fd_tag"), "_" => " ")
end


@delay function hfun_page_tags()
  pagetags = globvar("fd_page_tags")
  pagetags === nothing && return ""
  io = IOBuffer()
  tags = pagetags[splitext(locvar("fd_rpath"))[1]] |> collect |> sort
  several = length(tags) > 1
  write(io, """<div class="tags">$(hfun_svg_tag())""")
  for tag in tags[1:end-1]
      t = replace(tag, "_" => " ")
      write(io, """<a href="/tag/$tag/">$t</a>, """)
  end
  tag = tags[end]
  t = replace(tag, "_" => " ")
  write(io, """<a href="/tag/$tag/">$t</a></div>""")
  return String(take!(io))
end