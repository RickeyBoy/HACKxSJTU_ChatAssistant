# HACKxSJTU_ChatAssistant

### Usage:
1. Download and open with Xcode. Compile and run on iOS simulators or iOS mobiles.
2. Tap the Item Button at top right corner and informations will shows.(connection to internet is required)

### Functions:
1. Basic UI including information TableView , chating details & Popover window contains search results
2. Fetch data through RESTful API(url packaged using OpenWhisk) And resolve data structrue from JSON into Swift NSDictionary. Data contains entities(and related information) and user's emotions.
3. Capture data (messages sent from other users or typing from keyboard) and update to cloud through APIs(also packaged using OpenWhisk).
4. Present entities and related Wiki information in a Popover window. Textfield at the bottom may change colors corresponding to the emotions(Relations between emotions and colors are same as *Inside Out*). 
5. Real-time data pipelines and streaming between two iOS mobile phones through Kafka.(*Publishing data is still remained to finish)

### Implement Details:
- UI:
- Entities pickup and emotions analyse:
- URL packaging:
- Chat content updating and data fetching:
- Message receving:
