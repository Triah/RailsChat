import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {

  const current_chat_room_header = document.getElementById('chat_header');
  if (current_chat_room_header == null) {
    return;
  }

  const room_id = current_chat_room_header.getAttribute('data-header-chat-room-id');
  const logged_in_user = current_chat_room_header.getAttribute('data-header-chat-room-user-id')

  updateScroll();

  consumer.subscriptions.create({ channel: "ChatChannel", room: room_id }, {
    connected() {
    },

    disconnected() {
    },

    received(data) {
      insertMessageHtmlAtLastIndex(data)
      updateScroll();
    }
  });

  //Inserts the created message at the bottom of the table
  function insertMessageHtmlAtLastIndex(data) {
      const table = document.getElementById('message_table');
      const index = table.rows.length;
      if (logged_in_user == data.author_id) {
        table.insertRow(index).innerHTML = createHtmlMessageForOwner(data);
      } else {
        table.insertRow(index).innerHTML = createHtmlMessageForReceiver(data);
      }
  }

  //Creates a new message in a chat using the styling for the owner of the message
  function createHtmlMessageForOwner(data) {
    return '<tr>' 
    + '<td class="float-end">'
    + '<div class="float-start">' 
    + '<div class="text-start" style="font-size: 12px">'
    + '<img style="height:12px;width:12px;" src="' + data.avatar_url + '">'
    + data.author_name
    + '</div>'
    + '<div class="bg-success p-3 text-white rounded border border-secondary shadow-lg">'
    + data.content
    + '</div>'
    + '<div class="text-end mb-2" style="font-size: 12px">'
    + data.created_at
    + '</div>'
    + '</div>'
    + '</td>'
    + '</tr>'
  }

  //Creates a new message in the chat using the styling for receivers of the message
  function createHtmlMessageForReceiver(data) {
        return '<tr>' 
    + '<td>'
    + '<div class="float-start">' 
    + '<div class="text-start" style="font-size: 12px">'
    + '<img style="height:12px;width:12px;" src="' + data.avatar_url + '">'
    + data.author_name
    + '</div>'
    + '<div class="bg-primary p-3 text-white rounded border border-secondary shadow-lg">'
    + data.content
    + '</div>'
    + '<div class="text-end mb-2" style="font-size: 12px">'
    + data.created_at
    + '</div>'
    + '</div>'
    + '</td>'
    + '</tr>'
  }

  //Ensures the chat is always scrolled to the bottom when a new message is created and on initial load
  function updateScroll(){
    var chat_box = document.getElementById("chat_box");
    chat_box.scrollTop = chat_box.scrollHeight;
  }
});

