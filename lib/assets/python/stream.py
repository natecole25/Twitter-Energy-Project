

api_key = 'your_api_key'
secret_key = 'Your_api_secret_key'

from dateutil.parser import parse
import requests
import os
import json
import time
from datetime import datetime
import pandas as pd
from threading import Thread
from pprint import pprint

records_per_file = 5000  # Replace this with the number of tweets you want to store per file
file_path = "C:/Users/ncole/OneDrive/Desktop/Twitter Stream Files/"  # Replace with appropriate file path followed by / where you want to store the file

count = 0
row_counter = 0
file_object = None
file_name = "Energy Tweets"

def get_bearer_token(key, secret):
    response = requests.post(
        "https://api.twitter.com/oauth2/token",
        auth=(key, secret),
        data={'grant_type': 'client_credentials'},
        headers={"User-Agent": "Nate's Energy Policy Exploration"})

    if response.status_code is not 200:
        raise Exception(f"Cannot get a Bearer token (HTTP %d): %s" % (response.status_code, response.text))

    body = response.json()
    return body['access_token']


# To set your enviornment variables in your terminal run the following line:
# export 'BEARER_TOKEN'='<your_bearer_token>'
bearer_token = get_bearer_token(api_key, secret_key)
concat_this = []

def bearer_oauth(r):
    """
    Method required by bearer token authentication.
    """

    r.headers["Authorization"] = f"Bearer {bearer_token}"
    r.headers["User-Agent"] = "v2FilteredStreamPython"
    return r

def save_data_again(item, row_counter):
    global concat_this, file_object, file_name
    #Saves File Every 300
    tweet_info_dict = {}
    pprint(item)
    for key, value in item['data']['public_metrics'].items():
        tweet_info_dict[key] = value
    item['data'].pop('public_metrics')
    item['matching_rules'][0].update(item['data'])
    item['matching_rules'][0].update(tweet_info_dict)

    #for key, value in item['matching_rules'][0]['public_metrics']:
    item_flattened = item['matching_rules'][0]
    pprint(item_flattened)

    #Make post request to website.
    base_url = 'https://energy-sentiment-tweet-tracker.herokuapp.com/create_tweets_remotely'
    payload = {'tweet_id': int(item_flattened['id']), 'date_tweeted': parse(item_flattened['date'].replace(',', '')), 'tag': item_flattened['tag'],
               'tweet_text': item_flattened['text'], 'retweet_count': int(item_flattened['retweet_count'])}
    headers = {
        'content-type': "application/json"  # <-- only this header is needed
    }
    response = requests.post(base_url, headers, params=payload)
    print(response.status_code)
    #for key,value in item_flattened.items():
    #    item_flattened[key] = [value]






    #df_object = pd.DataFrame.from_dict(data= item_flattened, orient='columns')
    #print(df_object.head(1))
    #if row_counter % 50 != 0:
    #    concat_this.append(df_object)
    #else:
    #    final_df = pd.concat(concat_this, axis=0)
    #    final_df.set_index('date', inplace = True)
    #    final_df.to_excel(fr'{file_path}energypolicy-{file_name}-{row_counter}.xlsx')
    #    concat_this.clear()



        #final_df = pd.concat(concat_this, axis=0)
        #final_df.to_excel(fr'{file_path}energypolicy-{row_counter}.xlsx', encoding="utf-8")
        #concat_this.clear()

def save_data(item):
    global file_object, count, file_name
    if file_object is None:
        file_name = int(datetime.utcnow().timestamp() * 1e3)
        count += 1
        file_object = open(fr'{file_path}energypolicy-{file_name}.csv', 'a', encoding="utf-8")
        file_object.write("{}\n".format(item))
        return
    if count == records_per_file:
        #opens a new file if count grow to large
        file_object.close()
        count = 1
        file_name = f'energy_policy_twitter{count}'
        file_object = open(f'{file_path}energypolicy-{file_name}.csv', 'a', encoding="utf-8")
        file_object.write("{}\n".format(item))
    else:
        count += 1
        file_object.write("{}\n".format(item))


def get_rules():
    response = requests.get(
        "https://api.twitter.com/2/tweets/search/stream/rules", auth=bearer_oauth
    )
    if response.status_code != 200:
        raise Exception(
            "Cannot get rules (HTTP {}): {}".format(response.status_code, response.text)
        )
    #print(json.dumps(response.json()))
    return response.json()


def delete_all_rules(rules):
    if rules is None or "data" not in rules:
        return None

    ids = list(map(lambda rule: rule["id"], rules["data"]))
    payload = {"delete": {"ids": ids}}
    response = requests.post(
        "https://api.twitter.com/2/tweets/search/stream/rules",
        auth=bearer_oauth,
        json=payload
    )
    if response.status_code != 200:
        raise Exception(
            "Cannot delete rules (HTTP {}): {}".format(
                response.status_code, response.text
            )
        )
    #print(json.dumps(response.json()))


def set_rules(delete):
    # You can adjust the rules if needed
    sample_rules = [
        {"value": "(solar energy) OR (clean energy policy) OR (renewable portfolio standard) OR (renewable energy policy) lang:en", "tag": "general energy sentiment"},
        {"value": "from:FERC OR from:FERCWatch OR from:EnergyandPolicy OR from:ENERGY lang:en", "tag": "federal commentary"},
        {"value": "from:CalEnergy OR from:californiapuc OR from:California_ISO OR from:rtoinsider lang:en","tag": "california policy"},
        {"value": "from:pjminterconnect OR from:AriPeskoe OR from:MISO_energy lang:en", "tag": "Non California and Texas ISOs"},
        {"value": "(texas energy policy) OR (energy bill) -home OR (energy legislation)  from:ERCOT_ISO OR from:PUCTX OR from:MitchellFerman OR from:TxEnergyReport OR from:MISO_energy OR from:edward_klump lang:en", "tag":"texas policy"},
        {"value": "production tax credit OR solar incentives OR wind incentives OR solar tax OR investment tax credit OR sustainable infrastructure lang:en", "tag": "renewable incentives"},
        {"value": "nextera energy OR NextEra Energy OR NextEra Resources lang:en", "tag": "NextEra news"},
        {"value": "Fred Tropical Storm OR Fred Hurricane OR #HurricaneFred", "tag": "Hurricane Fred"}
    ]
    payload = {"add": sample_rules}
    response = requests.post(
        "https://api.twitter.com/2/tweets/search/stream/rules",
        auth=bearer_oauth,
        json=payload,
    )
    if response.status_code != 201:
        raise Exception(
            "Cannot add rules (HTTP {}): {}".format(response.status_code, response.text)
        )
    #print(json.dumps(response.json()))


def get_stream(set):
    global row_counter
    response = requests.get(
        "https://api.twitter.com/2/tweets/search/stream?tweet.fields=public_metrics&user.fields=public_metrics", auth=bearer_oauth, stream=True
    )
    print(response.status_code)
    if response.status_code != 200:
        raise Exception(
            "Cannot get stream (HTTP {}): {}".format(
                response.status_code, response.text
            )
        )
    for response_line in response.iter_lines():
        if response_line:
            row_counter += 1
            json_response = json.loads(response_line)
            json_response['matching_rules'][0].update({"date": datetime.now().strftime("%m/%d/%Y, %H:%M:%S")})
            #print(json_response)
            save_data_again(json_response,row_counter)
            #print(json.dumps(json_response, indent=4, sort_keys=True))



def main():
    rules = get_rules()
    delete = delete_all_rules(rules)
    set = set_rules(delete)
    get_stream(set)


if __name__ == "__main__":
    main()


