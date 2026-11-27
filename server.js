const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');

const root = __dirname;
const mime = { '.html': 'text/html; charset=utf-8', '.png': 'image/png', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8', '.sql': 'text/plain; charset=utf-8' };
const publicFiles = new Set(['index.html', 'logo-saigon-connection.png']);
const server = http.createServer((req, res) => {
  const pathname = new URL(req.url, 'http://localhost').pathname;
  if (pathname === '/config.js') {
    res.writeHead(200, { 'Content-Type': 'text/javascript; charset=utf-8', 'Cache-Control': 'no-store' });
    res.end(`window.APP_CONFIG=${JSON.stringify({ supabaseUrl: process.env.SUPABASE_URL || '', supabaseAnonKey: process.env.SUPABASE_ANON_KEY || '' })};`);
    return;
  }
  const relative = pathname === '/' ? 'index.html' : decodeURIComponent(pathname).replace(/^\/+/, '');
  if (!publicFiles.has(relative)) { res.writeHead(404).end('Not found'); return; }
  const file = path.resolve(root, relative);
  if (!file.startsWith(root + path.sep)) { res.writeHead(403).end('Forbidden'); return; }
  fs.readFile(file, (err, body) => {
    if (err) { res.writeHead(404).end('Not found'); return; }
    res.writeHead(200, { 'Content-Type': mime[path.extname(file)] || 'application/octet-stream' });
    res.end(body);
  });
});
server.listen(Number(process.env.PORT) || 3000, '0.0.0.0');

