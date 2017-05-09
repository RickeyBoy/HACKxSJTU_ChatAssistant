import json
import urllib

def try_url(url):
    try:
        result = urllib.urlopen(url).read()
        return result
    except Exception:
        print("No luck: {0}".format(url))
        return False

def clean(string):
    clstr = ""
    i = 0
    while(i < len(string)):
        a = string[i]
        if(string[i] == "<" ):
            i += 1
            while(string[i]!=">"):
                i += 1
            i += 1
        else:
            clstr += string[i]
            i += 1
    return clstr

def main(args):
    item = args.get("item","NULL")
    if(item == "NULL"):
        return {"error input":"NULL"}

    wiki_query ='''http://en.wikipedia.org/w/api.php?action=query&
    prop=extracts&format=json&exintro=&titles='''

    ilist = item.split(" ")
    string = ""
    for i in ilist:
        string += i + "+"
    string = string[:len(string) - 1]
    res = try_url(wiki_query + string)
    # print res
    res_json = json.loads(res)
    try:
        extract = res_json["query"]["pages"]
        extract = extract[extract.keys()[0]]
        extract = extract["extract"]
        extract = extract.encode("utf8")

        slist = extract.split(". ")
        if (slist is not None):
            extract = slist[0] + "."
        extract = clean(extract)
        print extract
        return {"extract":extract}
    except:
        return{"extract":"Not Found!"}