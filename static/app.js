$(document).on('ready turbolinks:load', function () {

    $('.copy-paste button').click(function () {
        const text = $(this).parent('.copy-paste').find('input').val();

        navigator.clipboard.writeText(text).then(function() {
            console.log('Async: Copying to clipboard was successful!');
        }, function(err) {
            console.error('Async: Could not copy text: ', err);
        });
    });
});