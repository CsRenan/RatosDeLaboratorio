$('$a[rel="license"]').click(function() {$.get('licenca.html', function(data) {  $(data).appendTo('#licenca').alert(); } );});
