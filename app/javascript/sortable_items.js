Testeroni.SortableItems = (function(el) {
  var self = this;

  self.init = function(el) {
    self.el = el;
    self.render();
  };

  self.render = function() {
    var updateUrl = self.el.data('update-url')
    self.el.sortable({
      stop: function(event, ui) {
        var itemEls = self.el.find('.sortable-item');
        var itemIds = _.map(itemEls, function(itemEl) { return $(itemEl).data('item-id') });
        $.ajax({
          type: 'POST',
          beforeSend: function(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
          url: updateUrl,
          data: { item_ids: itemIds }
        });
        return true;
      }
    });
  };

  self.init(el);

  return self;
});
