/* global TrelloPowerUp */
 var topWindow = window.top;

//debugger;
// we cannot get top window web3 from metamask as we are in an iframe on a different domain.

//var web3 = new Web3();

var WHITE_ICON = './images/icon-white.svg';
var GRAY_ICON = './images/icon-gray.svg';
var parkMap = {
  acad: 'Acadia National Park',
  arch: 'Arches National Park',
  badl: 'Badlands National Park',
  brca: 'Bryce Canyon National Park',
  crla: 'Crater Lake National Park',
  dena: 'Denali National Park',
  glac: 'Glacier National Park',
  grca: 'Grand Canyon National Park',
  grte: 'Grand Teton National Park',
  olym: 'Olympic National Park',
  yell: 'Yellowstone National Park',
  yose: 'Yosemite National Park',
  zion: 'Zion National Park'
};

var getBadges = function(t){
  return {
    dynamic: function(){
      return {
        title: 'Funding', // for detail badges only
        text: 'Ξ ' + (Math.random() * 100).toFixed(0).toString(),
        refresh: 10
      }
    }
  }
};

var boardButtonCallback = function(t){
  return t.popup({
    title: 'Popup List Example',
    items: [
      {
        text: 'Open Overlay',
        callback: function(t){
          return t.overlay({
            url: './overlay.html',
            args: { rand: (Math.random() * 100).toFixed(0) }
          })
          .then(function(){
            return t.closePopup();
          });
        }
      },
      {
        text: 'Open Board Bar',
        callback: function(t){
          return t.boardBar({
            url: './board-bar.html',
            height: 200
          })
          .then(function(){
            return t.closePopup();
          });
        }
      }
    ]
  });
};

var cardButtonCallback = function(t){
  console.log(t);
    return t.overlay({
      url: './overlay.html',
      args: { rand: (Math.random() * 100).toFixed(0) }
    })
    .then(function(){
      return t.closePopup();
    });

};

TrelloPowerUp.initialize({
  'attachment-sections': function(t, options){
    // options.entries is a list of the attachments for this card
    // you can look through them and 'claim' any that you want to
    // include in your section.

    // we will just claim urls for Yellowstone

    // you can have more than one attachment section on a card
    // you can group items together into one section, have a section
    // per attachment, or anything in between.
      // if the title for your section requires a network call or other
      // potentially length operation you can provide a function for the title
      // that returns the section title. If you do so, provide a unique id for
      // your section
      return [{
        id: 'Yellowstone', // optional if you aren't using a function for the title
        claimed: 'claimed',
        icon: GRAY_ICON,
        title: 'Fund this card',
        content: {
          type: 'iframe',
          url: t.signUrl('./section.html', { arg: 'you can pass your section args here' }),
          height: 230
        }
      }];
    },


  'attachment-thumbnail': function(t, options){
      var pubkey = "0x000"
      // return an object with some  or all of these properties:
      // url, title, image, openText, modified (Date), created (Date), createdBy, modifiedBy
      return {
        url: 'https://testnet.etherscan.io/address/'+pubkey,
        title: pubkey,
        image: {
          url: 'https://chart.googleapis.com/chart?cht=qr&chl='+pubkey+'&chs=256x256&choe=UTF-8&chld=L|2',
          logo: true // false if you are using a thumbnail of the content
        },
        openText: 'Check it on Etherscan'
      };

  },
  'board-buttons': function(t, options){
    return [{
      icon: WHITE_ICON,
      text: 'Trelleth',
      callback: boardButtonCallback
    }];
  },
  'card-badges': function(t, options){
    return getBadges(t);
  },
  'card-buttons': function(t, options) {
    return [{
      icon: GRAY_ICON,
      text: 'Trelleth',
      callback: cardButtonCallback
    }];
  },
  'card-detail-badges': function(t, options) {
    return getBadges(t);
  },
  'card-from-url': function(t, options) {
    var parkName = formatNPSUrl(t, options.url);
    if(parkName){
      return {
        name: parkName,
        desc: 'An awesome park: ' + options.url
      };
    } else {
      throw t.NotHandled();
    }
  },
  'format-url': function(t, options) {
    var parkName = formatNPSUrl(t, options.url);
    if(parkName){
      return {
        icon: GRAY_ICON,
        text: parkName
      };
    } else {
      throw t.NotHandled();
    }
  },
  'show-settings': function(t, options){
    return t.popup({
      title: 'Settings',
      url: './settings.html',
      height: 184
    });
  }
});
