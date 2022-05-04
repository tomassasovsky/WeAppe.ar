import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '3m', target: 5000 }, // below normal load
    { duration: '2m', target: 5000 }, // below normal load
    { duration: '3m', target: 10000 }, // below normal load
    { duration: '2m', target: 10000 }, // below normal load
    { duration: '1m', target: 0 }, // scale down. Recovery stage.
  ],
};

export default function () {
  const req = {
    method: 'GET',
    url: 'http://localhost:5000/test',
  };

  http.batch([req]);

  sleep(1);
}