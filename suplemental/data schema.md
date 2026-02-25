Act as an expert backend developer and database architect. I am building a worship song app for worship teams. 

The core features of the app are:
1. Users can manage a database of songs.
2. Users can create setlists (lists of songs) for their team.
3. Users must be able to share and view these setlists "live" (real-time sync where the leader changes the current song, and everyone else's screen updates).
4. Users must be able to view these setlists and songs "offline" (requiring an offline-first sync mechanism based on modification dates).

Here is the exact schema I want for the core `Song` entity:
- id (UUID)
- title (String)
- authors (String or Array of Strings)
- original_key (String)
- lyrics (Text - will store ChordPro formatted text)
- media_link (String - e.g., YouTube or Spotify link)
- tempo_bpm (Integer)
- time_signature (String - e.g., "4/4", "6/8")
- themes (Array of Strings - e.g., ["Communion", "Easter"])
- creation_date (Timestamp)
- modified_date (Timestamp - crucial for offline sync)
- approval_status (Enum/String - e.g., "draft", "approved")

Based on these requirements, please provide the following:

1. **Database Models:** Provide the database schema PostgreQL. In addition to the `Song` model above, please generate the necessary relational models to support building lists and teams (e.g., `Setlist`, `Setlist_Item`, `Team`, `User`). Make sure `Setlist_Item` can override the song's key for a specific list.
2. **Offline-First Sync Strategy:** Explain how the backend should handle requests to support an offline-first mobile app using the `modified_date` fields. Write a sample API endpoint/query for the "sync" pull.
3. **Live Sync Strategy:** Suggest the best backend technology/approach Dart backend and our own server to handle the "Live Mode" where the leader's screen controls the band's screens. Outline what the data payload would look like when the leader switches to the next song.
4. **API Endpoints:** A brief list of the core REST endpoints needed to support CRUD operations for the songs and setlists.
5. We want to use Dart Shelf for our server.

Please write clean, well-commented code for the models and backend logic.