package main

import (
    "log"
    "github.com/moovweb/gokogiri"
)

type PageParser struct {
  data []byte
}

func NewPageParser(data []byte) *PageParser {
  return &PageParser{data}
}

func (page PageParser) ParseLinks() []string {
  if page.data == nil {
    log.Fatal("Tried to parse page without data")
    return nil
  }
  
  doc, _ := gokogiri.ParseHtml(page.data)
  links, err := doc.Search("//a")
  if err != nil {
      log.Fatal("Cannot parse document")
      return nil
  }
  
  var hrefs []string
  for _,node := range links {
    if node.Attributes()["href"] != nil {
      hrefs = append(hrefs, node.Attributes()["href"].String())
    }
  }
  
  doc.Free()
  return hrefs
}