import ssl
from kafka import KafkaConsumer

def main(args):
    kafka_brokers_sasl = [
        "kafka02-prod01.messagehub.services.us-south.bluemix.net:9093"]
    sasl_plain_username = "CymYXmAPCST69Lwm"
    sasl_plain_password = "4k7s8qCWERx2Bl3bmbJu9932joHuA3nW"

    sasl_mechanism = 'PLAIN'       # <-- changed from 'SASL_PLAINTEXT'
    security_protocol = 'SASL_SSL'

    oldoffset = args.get("offset","0")
    oldoffset = int(oldoffset)

    # Create a new context using system defaults, disable all but TLS1.2
    context = ssl.create_default_context()
    context.options &= ssl.OP_NO_TLSv1
    context.options &= ssl.OP_NO_TLSv1_1
    try:
        consumer = KafkaConsumer('kar2',
                                 bootstrap_servers=kafka_brokers_sasl,
                                 sasl_plain_username=sasl_plain_username,
                                 sasl_plain_password=sasl_plain_password,
                                 security_protocol=security_protocol,
                                 ssl_context=context,
                                 sasl_mechanism=sasl_mechanism)
        consumer.topics()
        part = consumer.assignment()

        # print part
        part = part.pop()
        offset = consumer.position(partition=part)
        # print offset
        consumer.seek(part,oldoffset)
        # print consumer.position(partition=part)
        message_queue = consumer.poll(timeout_ms=2000, max_records = 20)
        message_queue = message_queue[message_queue.keys()[0]]
        message_dict = {}
        for i in message_queue:
            message_dict[i.offset] = i.value
        print message_dict
        return message_dict
    except:
        return {"-1":oldoffset}

# main({"offset":20})

