import * as functions from 'firebase-functions';
import * as Cors from 'cors';
import * as os from 'os';
import * as path from 'path';
import * as fs from 'fs';
import * as fbAdmin from 'firebase-admin';
import * as uuid from 'uuid/v4';
import { Storage } from '@google-cloud/storage';
import * as Busboy from 'busboy';
const cors = Cors({ origin: true });

const gcconfig = {
  projectId: 'flutterate-api',
  keyFilename: 'flutterate-api-firebase-adminsdk-cc9jd-57844efdd3.json'
};

const gcs = new Storage(gcconfig);

fbAdmin.initializeApp({
  credential: fbAdmin.credential.cert(require('../flutterate-api-firebase-adminsdk-cc9jd-57844efdd3.json'))
});

export const storeImage = functions.https.onRequest((req: functions.Request, res: functions.Response) => {
  return cors(req, res, () => {
    if (req.method !== 'POST') {
      return res.status(500).json({ message: 'Not allowed.' });
    }

    if (
      !req.headers.authorization ||
      !req.headers.authorization.startsWith('Bearer ')
    ) {
      return res.status(401).json({ error: 'Unauthorized.' });
    }

    let idToken;
    idToken = req.headers.authorization.split('Bearer ')[1];

    const busboy = Busboy({ headers: req.headers });
    let uploadData;
    let oldImagePath;

    busboy.on('file', (fieldname, file, filename, encoding, mimetype) => {
      const filePath = path.join(os.tmpdir(), filename);
      uploadData = { filePath: filePath, type: mimetype, name: filename };
      file.pipe(fs.createWriteStream(filePath));
    });

    busboy.on('field', (fieldname, value) => {
      oldImagePath = decodeURIComponent(value);
    });

    busboy.on('finish', () => {
      const bucket = gcs.bucket('flutterate-api.appspot.com');
      const id = uuid();
      let imagePath = 'images/' + id + '-' + uploadData.name;
      if (oldImagePath) {
        imagePath = oldImagePath;
      }

      return fbAdmin
        .auth()
        .verifyIdToken(idToken)
        .then(decodedToken => {
          return bucket.upload(uploadData.filePath, {
            destination: imagePath,
            metadata: {
              metadata: {
                contentType: uploadData.type,
                firebaseStorageDownloadTokens: id
              }
            }
          });
        })
        .then(() => {
          return res.status(201).json({
            imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/' +
              bucket.name +
              '/o/' +
              encodeURIComponent(imagePath) +
              '?alt=media&token=' +
              id,
            imagePath: imagePath
          });
        })
        .catch(error => {
          return res.status(401).json({ error: 'Unauthorized!' });
        });
    });
    return busboy.end(req.body);
  });
});

export const deleteImage = functions.database
  .ref('/products/{productId}')
  .onDelete(snapshot => {
    const imageData = snapshot.val();
    const imagePath = imageData.imagePath;

    const bucket = gcs.bucket('flutterate-api.appspot.com');
    return imagePath === 'images/flutter.png' ? null : bucket.file(imagePath).delete();
  });

