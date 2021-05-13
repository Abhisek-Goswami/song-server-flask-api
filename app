from flask import Flask 
from flask import make_response, request, jsonify
from flask_mongoengine import MongoEngine
from api_constants import mongodb_password
import datetime

app= Flask(__name__)

database_name = "API"
DB_URI = "mongodb+srv://AbhisekG:{}@pythoncluster.uwuv1.mongodb.net/{}?retryWrites=true&w=majority" .format(mongodb_password, database_name)
app.config["MONGO_DB"] = DB_URI
db= MongoEngine()
db.init_app(app)


class SONG(db.Document):
    SONG_id = db.IntField()
    NAME_song=db.StringField(100)
    DURATION_song = db.IntField()
    upload_time_song= db.datetime.datetime.now.timestamp()

    def to_json(self):
        #this converts the method to json so it helps with json response
        return{
            "SONG_id": self.SONG_id,
            "NAME_song":self.NAME_song,
            "DURATION_song": self.DURATION_song,
            "upload_time_song": self.upload_time_song
}
class PODCAST(db.Document):
     PODCAST_id = db.IntField()
     NAME_pod=db.StringField(100)
     DURATION_pod = db.IntField()
     upload_time_pod= db.datetime.datetime.now.timestamp()
     PARTICIPANTS=db.StringField(100)
     host=db.StringField(100)
    
def to_json(self):
        
        return{
            "PODCAST_id": self.PODCAST_id,
            "NAME_pod": self.NAME_pod,
            "DURATION_pod": self.DURATION_pod,
            "upload_time_pod": self.uploaded_time_pod,
            "PARTICIPANTS":self.PARTICIPANTS,
            "host":self.host
        }
class AUDIOBOOK(db.Document):
     AB_id = db.IntField()
     Title=db.StringField(100)
     DURATION_AB = db.IntField()
     upload_time_AB= db.datetime.datetime.now.timestamp()
     Author=db.StringField(100)
     narrator=db.StringField(100)
    
def to_json(self):
        
        return{
            "AB_id": self.AB_id,
            "Title":self.Title,
            "DURATION_AB":self.DURATION_AB,
            "upload_time_AB":self.upload_time_AB,
            "Author":self.Author,
            "narrator":self.narrator
        }
        

@app.route('/' , methods=['POST'])
@app.route('/SONG/create', methods=['POST'])
@app.route('/PODCAST/create', methods=['POST'])
@app.route('/AUDIOBOOK/create', methods=['POST'])

def create():
    Song1 = SONG(SONG_id=1 , NAME_song="A bright day" , DURATION_song=250 ) 
    Song2 = SONG(SONG_id=2 , NAME_song="This too shall pass" , DURATION_song=360 )

    Podcast1=PODCAST(PODCAST_id=1 , NAME_pod="SUCCESS IS THE KEY" , DURATION_pod=1200 , PARTICIPANTS="john,Abhisek,Imtiaz" , host="Dr.Larry")
    Podcast2=PODCAST(PODCAST_id=2 , NAME_pod="KEY TO LIFE" , DURATION_pod=1200 , PARTICIPANTS="johny,Avi,Imaz" , host="Dr.Liza") 
    
    audiobook1=AUDIOBOOK(AB_id=1 , Title="Rhymes of life" , DURATION_AB=1233 , AUTHOR="Patrick J" , narrator="MATT H")
    audiobook2=AUDIOBOOK(AB_id=2 , Title="A Road to heaven" , DURATION_AB=1233 , AUTHOR="Paty J" , narrator="Maverick H")

    Song1.save()
    Song2.save()

    Podcast1.save()
    Podcast2.save()

    audiobook1.save()
    audiobook2.save()
    
    return make_response("Action is sucessful" , 200)




@app.route('/' , methods=['GET' , 'POST'])
@app.route('/song/get_update', methods=['GET' , 'POST'])
@app.route('/podcast/get_update', methods=[ 'GET' , 'POST'])
@app.route('/audiobook/get_update', methods=[ 'GET' , 'POST'] )

def get_update():
    if request.method == "GET":
        print(request.method)
        Songs=[]
        Podcasts=[]
        audiobooks=[]
        for Song in SONG.objects:
            Songs.append(Song)
            return make_response(jsonify(Songs),200)
        
        for Podcast in PODCAST.objects:
            Podcasts.append(Podcast)
            return make_response(jsonify(Podcasts),200)

        for audiobook in AUDIOBOOK.objects:
            audiobooks.append(audiobook)
            return make_response(jsonify(audiobooks),200)   
    
    
    
    
    
    
    elif request.method == "POST":
        content=request.json

        Song = SONG(SONG_id=content['SONG_id'],NAME_song=content['NAME_song'],DURATION_song=content['DURATION_song'])
        Podcast = PODCAST(PODCAST_id=content['PODCAST_id'],NAME_pod=content['NAME_pod'],DURATION_pod=content['DURATION_pod'],PARTICIPANTS=content['PARTICIPANTS'],host=content['host'])
        audiobook = AUDIOBOOK(AB_id=content['AB_id'],Title=content['Title'],DURATION_AB=content['DURATION_AB'],AUTHOR=content['AUTHOR'],narrator=content['narrator'])

        Song.save()
        Podcast.save()
        audiobook.save()
        return make_response ("Action is successful:", 200)


@app.route('/', methods=['PUT'])
@app.route('/song/update/<SONG_id>' , methods=['PUT'])
@app.route('/podcast/update/<PODCAST_id>', methods=['PUT'])
@app.route('/audiobook/update/<AB_id>' , methods=['PUT'])
def update(SONG_id , PODCAST_id , AB_id):

    if request.method == "PUT":
        content = request.json
        Song_obj = SONG.objects(SONG_id=SONG_id).first()
        Podcast_obj = PODCAST.objects(PODCAST_id=PODCAST_id).first()
        audiobook_obj = AUDIOBOOK.obejcts(AB_id=AB_id).first()
        Song_obj.update(NAME_song=content['Name_song'] , DURATION_song=content['DURATION_song'])
        Podcast_obj.update(PARTICIPANTS=content['PARTICIPANTS'] , host=content['host'])
        audiobook_obj.update(narrator=content['narrator'])
        return make_response("Action is sucessful" , 200)


@app.route('/', methods=['DELETE'])
@app.route('/song/delete/<SONG_id>' , methods=['DELETE'])
@app.route('/podcast/delete/<PODCAST_id>', methods=['DELETE'])
@app.route('/audiobook/delete/<AB_id>' , methods=['DELETE'])
def delete(SONG_id , PODCAST_id , AB_id):
    if request.method == "DELETE":
        Song_obj = SONG.objects(SONG_id=SONG_id).first()
        Podcast_obj = PODCAST.objects(PODCAST_id=PODCAST_id).first()
        audiobook_obj = AUDIOBOOK.obejcts(AB_id=AB_id).first()
        Song_obj.delete()
        Podcast_obj.delete()
        audiobook_obj.delete()
        return make_response("Action is sucessful" , 200)


    if __name__ == '__main__' :
        app.run(debug=True)


    

