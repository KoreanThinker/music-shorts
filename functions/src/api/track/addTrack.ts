import {firestore} from 'firebase-admin';
import {https} from 'firebase-functions';
import {HttpsError} from 'firebase-functions/v1/https';
import {AddTrackData} from '../../../type/api/track';
import {Track} from '../../../type/firestore';
import {admin, adminGuard} from '../../service/firebase';
import {spotify} from '../../service/spotify';

export const addTrack = https.onCall(async (data: AddTrackData, context) => {
  const {spotifyTrackId} = data;

  if (!context.auth) throw new HttpsError('unauthenticated', 'Sign in require');
  await adminGuard(context.auth.uid);

  const prevSpotifyTrack = await admin
    .firestore()
    .collection('track')
    .where('spotifyId', '==', spotifyTrackId)
    .get();
  if (prevSpotifyTrack.size !== 0)
    throw new HttpsError('already-exists', 'Spotify track already exists');

  const {body: spotifyTrack} = await spotify.getTrack(spotifyTrackId);

  const snapshot = await admin
    .firestore()
    .collection('track')
    .add({
      createdAt: firestore.Timestamp.now(),
      spotifyId: spotifyTrack.id,
      artist_names: spotifyTrack.artists.map(v => v.name),
      name: spotifyTrack.name,
      duration_ms: spotifyTrack.duration_ms,
      preview_url: spotifyTrack.preview_url,
      image: spotifyTrack.album.images[0].url,
      spotify_data: spotifyTrack,
    } as Track);

  return (await snapshot.get()).data();
});