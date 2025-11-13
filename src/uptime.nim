import asyncdispatch, httpclient, json, strutils, uri

const api = "https://get.uptime.is/api"
var headers = newHttpHeaders({
    "Connection": "keep-alive",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
    "Host": "get.uptime.is",
    "Accept": "application/json"
})

proc get_sla_downtime*(sla: float): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let response = await client.get(api & "?sla=" & $sla)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc get_complex_sla_downtime*(
    sla: float,
    durations: seq[int] = @[]
): Future[JsonNode] {.async.} =
  
  let client = newAsyncHttpClient()
  client.headers = headers
  
  var url = api & "?sla=" & $sla
  
  # Добавляем продолжительности для каждого дня недели
  if durations.len > 0:
    for dur in durations:
      url &= "&dur=" & $dur
  
  try:
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc get_reverse_sla*(downtime: string): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let encoded_downtime = encodeUrl(downtime)
    let response = await client.get(api & "?down=" & encoded_downtime)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc get_complex_reverse_sla*(
    downtime: string,
    durations: seq[int] = @[]
): Future[JsonNode] {.async.} =
  
  let client = newAsyncHttpClient()
  client.headers = headers
  
  let encoded_downtime = encodeUrl(downtime)
  var url = api & "?down=" & encoded_downtime
  if durations.len > 0:
    for dur in durations:
      url &= "&dur=" & $dur
  
  try:
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()
