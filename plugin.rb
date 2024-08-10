enabled_site_setting :discourse_step_iframe_enabled

after_initialize do
  on(:post_process_cooked) do |doc, post|
    post.uploads.each do |upload|
      if upload.original_filename.end_with?('.step')
        file_url = upload.url
        iframe_code = "<iframe src='https://sharecad.org/cadframe/load?url=#{file_url}&lang=en&user=0' width='100%' height='600' frameborder='0'></iframe>"

        # Insert iframe after the upload link in the post content
        doc.css("a[href='#{upload.url}']").each do |link|
          link.after(iframe_code)
        end

        # Update the post content
        post.update(cooked: doc.to_html)
      end
    end
  end
end

