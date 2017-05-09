import ssl
from kafka import *

def main(args):
    mesg = args.get("mesg","NULL")
    if(mesg == "NULL"):
        return {"result": -1}
        print "NULL message"

    kafka_brokers_sasl = [
        "kafka02-prod01.messagehub.services.us-south.bluemix.net:9093"]

    sasl_plain_username = "CymYXmAPCST69Lwm"
    sasl_plain_password = "4k7s8qCWERx2Bl3bmbJu9932joHuA3nW"

    sasl_mechanism = 'PLAIN'       # <-- changed from 'SASL_PLAINTEXT'
    security_protocol = 'SASL_SSL'

    # Create a new context using system defaults, disable all but TLS1.2
    context = ssl.create_default_context()
    context.options &= ssl.OP_NO_TLSv1
    context.options &= ssl.OP_NO_TLSv1_1


    try:
        producer = KafkaProducer(bootstrap_servers = kafka_brokers_sasl,
                                 sasl_plain_username = sasl_plain_username,
                                 sasl_plain_password = sasl_plain_password,
                                 security_protocol = security_protocol,
                                 ssl_context = context,
                                 sasl_mechanism = sasl_mechanism,
                                 acks = 0,
                                 retries = 5)
        if(type(mesg) is int):
            mesg = str(mesg)

        mesg = mesg.encode("utf8")
        producer.send(topic=b'kar2',key=b'mesg',value = mesg)
        print "success send"
        producer.close()
        return {"result":1}
    except:
        print "kafka send wrong"
        return {"result":0}

# main({"mesg":"i am happy"})