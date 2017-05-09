import json
import urllib
from watson_developer_cloud import NaturalLanguageUnderstandingV1
import watson_developer_cloud.natural_language_understanding.features.v1 as \
    features

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

def dic2item(response):
    itemlist = []
    tempitem = []
    for i in range(len(response[u'entities'])):
        tempitem = []
        text = response[u'entities'][i][u'text']
        tempitem.append(text)
        tempitem.append(response[u'entities'][i][u'relevance'])
        tempitem.append(response[u'entities'][i][u'count'])
        itemlist.append(tempitem)
    return itemlist

def emotion2result(response):
    emotions = [u'anger', u'joy', u'sadness', u'fear', u'disgust']
    result = {}
    for i in range(5):
        result[emotions[i]] = response[u'emotion'][u'document'][u'emotion'][emotions[i]]
    return result

def categories2result(response):
    result = {}
    for i in range(len(response[u'categories'])):
        label = response[u'categories'][i][u'label']
        result[label] = response[u'categories'][i][u'score']
    return result

def concepts2result(response):
    result = {}
    for i in range(len(response[u'concepts'])):
        tempitem = []
        text = response[u'concepts'][i][u'text']
        tempitem.append(response[u'concepts'][i][u'relevance'])
        tempitem.append(response[u'concepts'][i][u'dbpedia_resource'])
        result[text] = tempitem
    return result

def main(args):
    natural_language_understanding = NaturalLanguageUnderstandingV1(
        version='2017-02-27',
        username='3c7f46fd-5308-46db-b55a-502352b72261',
        password='1EssQSp6Zaik')

    features_list = [features.Categories(),
                     features.Concepts(),
                     features.Emotion(),
                     features.Entities(),
                     features.Keywords(),
                     features.MetaData(),
                     features.Relations(),
                     features.Sentiment()]
    input_param_list = ['Categories', 'Concepts', 'Emotion', 'Entities', 'Keywords', 'MetaData', 'Relations', 'Sentiment']
    input_param = args.get("type", "Emotion")
    
    response = natural_language_understanding.analyze(
        text = args.get("text", None),
        url = args.get("url", None),
        html = args.get("html", None),
        
        features=[features_list[input_param_list.index(input_param)]])
    
    if(args.get("type", "Emotion")=="Emotion"):
        result = emotion2result(response)
        return result
    if(args.get("type", "Emotion")=="Categories"):
        result = categories2result(response)
        return result
    if(args.get("type", "Emotion")=="Concepts"):
        result = concepts2result(response)
        return result
    if(args.get("type", "Emotion")!="Entities"):
        return response

    itemlist = dic2item(response)

    wiki_query = "http://en.wikipedia.org/w/api.php?action=query&" \
                 "prop=extracts&format=json&exintro=&titles="

    count = 0
    index = 0
    extractlist = {}
    while(count < 3 and index < len(itemlist)):
        temp = itemlist[index][0].encode("utf8")
        item = temp.split(" ")
        string = ""
        for i in item:
            string += i + "+"
        string = string[:len(string) - 1]
        res = try_url(wiki_query + string)
        # print res
        res_json = json.loads(res)
        extract = res_json["query"]["pages"]
        pagenum = extract.keys()[0]
        if(pagenum != "-1"):
            count += 1
            extract = extract[pagenum]
            extract = extract["extract"]
            extract = extract.encode("utf8")

            slist = extract.split(". ")
            if (slist is not None):
                extract = slist[0] + "."
            extract = clean(extract)
            extractlist[itemlist[index][0]] = extract
        index += 1
    if(extractlist == {}):
        return {"NULL":"NULL"}
    return extractlist

#print main({"text":"IBM is an American multinational technology company headquartered in New York, United States, with operations in over 170 countries.","type":"Entities"})
#print main({"text":"The Nobel Prize in Physics 1921 was awarded to Albert Einstein.","type":"Entities"})
print main({"text":"The Chinese Comac C919 airliner takes place.","type":"Concepts"})

