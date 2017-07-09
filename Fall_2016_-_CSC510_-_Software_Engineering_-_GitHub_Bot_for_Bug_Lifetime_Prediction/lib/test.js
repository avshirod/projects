var R = require("r-script");
// var out = R("ex-sync.R")
//   .data("hello world", 20)
//   .callSync();

var out = R("ex-sync.R")
  .data("blah")
  .callSync();
  
console.log(out);