$(document).on('turbolinks:load', function(){
  function gistContent() {

    document.querySelectorAll('.gist-content').forEach(function(gistElement) {
      const gistUrl = gistElement.getAttribute('data-gist-url');
      console.log("Found Gist URL:", gistUrl);

      if (gistUrl) {
        const gistId = gistUrl.split('/').pop();
        const apiUrl = `https://api.github.com/gists/${gistId}`;

        fetch(apiUrl)
          .then(response => response.json())
          .then(data => {
            console.log("Received Gist data:", data);

            for (let file in data.files) {
              const fileContent = data.files[file].content;
              const preElement = document.createElement('pre');
              preElement.textContent = fileContent;
              gistElement.appendChild(preElement);
            }
          })
          .catch(error => {
            console.error("Error loading Gist:", error);
          });
      }
    });
  }
  window.gistContent = gistContent;
  gistContent();
});