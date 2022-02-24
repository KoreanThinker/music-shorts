import {RequestHandler} from 'express';
import {spotify} from '../config/spotify';

const loginRequire: RequestHandler = async (req, res, next) => {
  try {
    spotify.setAccessToken(req.headers.access_token);
    const {body, statusCode} = await spotify.getMe();
    if (statusCode !== 200) throw body;
    req.me = body;
    next();
  } catch (error) {
    res.status(401).send(error);
  }
};

export default loginRequire;
