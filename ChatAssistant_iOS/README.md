# HACKxSJTU_ChatAssistant
## ChatAssistant_iOS

### Usage:
- Download and open with Xcode. Compile and run on iOS simulators or iOS mobiles.
- Tap the Item Button at top right corner and informations will shows.(connection to internet is required)

### Functions:
1. Basic UI including information TableView , chat details & Popover window contains search results
2. Fetch data through RESTful API(url encapsulated using OpenWhisk) And resolve data structrue from JSON into Swift NSDictionary. Data contains entities(and related information) and user's emotions.
3. Capture data (messages sent from other users or typing from keyboard) and update to cloud through APIs(also OpenWhisk).
4. Present entities and related Wiki information in a Popover window. Textfield at the bottom may change colors corresponding to the emotions(Relations between emotions and colors are same as *Inside Out*). 
5. Real-time data pipelines and streaming between two iOS mobile phones through Kafka.(*Publishing data is still remained to finish)

### iOS App Implement Details:
- UI:
    - Most are based on Storyboard 
    - Main structure: Tabbar + TableView
    - Chat view between two users: TableView with custom TableViewCell
    - Search results shows in a Popover window
- Chat content updating and data fetching: 
    - Combine data and RESTful API (a url) into a new url. Visit the new url and download the data. Transform it's format from JSON into NSDictionary in Swift. Then UI can response according to the NSDictionary data.
    - **Notice**: OpenWhisk is a powerful platform which automatically shows the usage of the API in different ways including Curl, Python and Swift. But it's always something wrong using Swift in that way(Others work well). At last I have to use another way to fetch data. You can find out that in the source code.
    - It takes time to fetch data we need. Multi-threading helps a lot.
- Message receving:
    - Almost the same as data fetching. Combine offset and url, then try to fetch data every 3 seconds.(Visit the url and get the result takes nearly 3 seconds)
    - Offset is strongly related to the number of messages. Every time one mobile gets a new message, offset adds one to itself.


### Fetch data though RESTful API:
- location: *chatViewController.swift*
    - *getJSON* method: visit the url and get *NSData*
    - *parseJSON* method: input *NSData*, output *NSDictionary*
    - *fetchData* method: call the two method above and get the result
- url usage:
    - url: the RESTful API, which can be visited directly though a browser.
    - You can add substring to the url to get the specific result. Substring looks like `?text=%22I+am+so+happy%22&type=Emotion`. 
    - requirement: 
        - `text` must be a sentence with `+` rather than black space.
        - `%22` represents `"`, can not replace by `\"`. 
        - `type=Emotion` or `type=Entities`. 
