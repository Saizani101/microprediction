echo "This script will run DefaultCrawler from a new virtual env"
echo "If it fails you might need to brew install python"
mkdir -p crawling_working_dir
cd crawling_working_dir
python3 -m venv crawling
source crawling/bin/activate
pip install --ugprade pip
pip install --upgrade wheel
pip install --upgrade microprediction
 
echo "------ Installation complete ------"
echo "Next, burning a write_key which will be your identity. This may take a long time."
sleep 3

python3 -c "from microprediction import new_key;WRITE_KEY = new_key();print(WRITE_KEY)" > "WRITE_KEY.txt"

sleep 3 
write_key=$(cat "WRITE_KEY.txt")
echo $write_key


START=`date +%s` 
while [ $(( $(date +%s) - 30000000 )) -lt $START ]; do
    write_key=$(cat "WRITE_KEY.txt")
    pip install --upgrade microprediction.git
    python3 -c "from microprediction import DefaultCrawler;crawler = DefaultCrawler(write_key='"$write_key"'); crawler.run()"
    echo "I guess something went wrong, or this is a scheduled update time. Not to worry either way. We shall resume in 60 seconds". 
    sleep 60
done


