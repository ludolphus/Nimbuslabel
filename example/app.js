var nimbuslabel = require('nimbus.label');

var win = Ti.UI.createWindow({
	backgroundColor:'#888'
});
win.open();

var text = '@ludolphus hello world emoji 😄 and #tagafteremoji other stuff € http://chimp.li/ work. And emoji on last line 😄😄😄😄😄';
var attr = [];
attr.push({type: 'font', value: {fontFamily: 'Times', fontSize: 10}, start: 0, length: text.length});
attr.push({type: 'color', value: '#ff0000', start: 0, length: text.length});
attr.push({type: 'link', value: 'mention://ludolphus', start: 0, length: 10});
attr.push({type: 'link', value: '#tagafteremoji', start: 36, length: 14});
attr.push({type: 'link', value: 'http://chimp.li/', start: 65, length: 16});

var l = nimbuslabel.createLabel({
	linkColor: '#ff8400',
	highlightedLinkBackgroundColor: '#007bff',
	numberOfLines: 2,
	attributedText: {text: text, attributes: attr},
	top:20,
	left:10,
	right:10,
	width:Ti.UI.FILL,
	height:Ti.UI.SIZE,
	touchEnable: true,
});

l.addEventListener('click', function(e) {
	Ti.API.log(e);
});

l.addEventListener('longpress', function(e) {
	Ti.API.log(e);
});

win.add(l);
