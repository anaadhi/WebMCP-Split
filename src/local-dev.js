import http from 'node:http';
import worker from './worker.js';

const port = Number(process.env.PORT || 8787);
const server = http.createServer(async (req, res) => {
  const response = await worker.fetch(new Request(`http://localhost:${port}${req.url}`));
  res.writeHead(response.status, Object.fromEntries(response.headers));
  res.end(Buffer.from(await response.arrayBuffer()));
});

server.listen(port, () => console.log(`Split Circle is running at http://localhost:${port}`));
