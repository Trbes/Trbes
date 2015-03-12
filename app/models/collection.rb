class Collection < ActiveRecord::Base
  VISIBLE_COLLECTIONS_COUNT = 3

  include RankedModel

  belongs_to :group, counter_cache: true, required: true
  has_many :collection_posts, -> { ordered }, dependent: :destroy, inverse_of: :collection
  has_many :posts, through: :collection_posts
  accepts_nested_attributes_for :collection_posts, allow_destroy: true

  validates :name, presence: true, uniqueness: true

  scope :visible, -> { where(visibility: true) }
  scope :not_used_for, -> (post) { where.not(id: post.collections.pluck(:id)) }
  scope :ordered, -> { rank(:row_order) }

  ranks :row_order, with_same: :group_id

  def collection_post_for(post)
    collection_posts.where(post: post).first
  end

  # rubocop:disable Metrics/LineLength
  FONT_AWESOME_ICONS = {
    web_application: %w(adjust anchor archive area-chart arrows arrows-h arrows-v asterisk at ban bar-chart barcode bars bed beer bell bell-o bell-slash bell-slash-o bicycle binoculars birthday-cake bolt bomb book bookmark bookmark-o briefcase bug building building-o bullhorn bullseye bus calculator calendar calendar-o camera camera-retro car caret-square-o-down caret-square-o-left caret-square-o-right caret-square-o-up cart-arrow-down cart-plus cc certificate check check-circle check-circle-o check-square check-square-o child circle circle-o circle-o-notch circle-thin clock-o cloud cloud-download cloud-upload code code-fork coffee cog cogs comment comment-o comments comments-o compass copyright credit-card crop crosshairs cube cubes cutlery database desktop diamond dot-circle-o download ellipsis-h ellipsis-v envelope envelope-o envelope-square eraser exchange exclamation exclamation-circle exclamation-triangle external-link external-link-square eye eye-slash eyedropper fax female fighter-jet file-archive-o file-audio-o file-code-o file-excel-o file-image-o file-pdf-o file-powerpoint-o file-video-o file-word-o film filter fire fire-extinguisher flag flag-checkered flag-o flask folder folder-o folder-open folder-open-o frown-o futbol-o gamepad gavel gift glass globe graduation-cap hdd-o headphones heart heart-o heartbeat history home inbox info info-circle key keyboard-o language laptop leaf lemon-o level-down level-up life-ring lightbulb-o line-chart location-arrow lock magic magnet male map-marker meh-o microphone microphone-slash minus minus-circle minus-square minus-square-o mobile money moon-o motorcycle music newspaper-o paint-brush paper-plane paper-plane-o paw pencil pencil-square pencil-square-o phone phone-square picture-o pie-chart plane plug plus plus-circle plus-square plus-square-o power-off print puzzle-piece qrcode question question-circle quote-left quote-right random recycle refresh reply reply-all retweet road rocket rss rss-square search search-minus search-plus server share share-alt share-alt-square share-square share-square-o shield ship shopping-cart sign-in sign-out signal sitemap sliders smile-o sort sort-alpha-asc sort-alpha-desc sort-amount-asc sort-amount-desc sort-asc sort-desc sort-numeric-asc sort-numeric-desc space-shuttle spinner spoon square square-o star star-half star-half-o star-o street-view suitcase sun-o tablet tachometer tag tags tasks taxi terminal thumb-tack thumbs-down thumbs-o-down thumbs-o-up thumbs-up ticket times times-circle times-circle-o tint toggle-off toggle-on trash trash-o tree trophy truck tty umbrella university unlock unlock-alt upload user user-plus user-secret user-times users video-camera volume-down volume-off volume-up wheelchair wifi wrench),
    transportation: %w(ambulance bicycle bus car fighter-jet motorcycle plane rocket ship space-shuttle subway taxi train truck wheelchair),
    gender: %w(circle-thin mars mars-double mars-stroke mars-stroke-h mars-stroke-v mercury neuter transgender transgender-alt venus venus-double venus-mars),
    file_type: %w(file file-archive-o file-audio-o file-code-o file-excel-o file-image-o file-o file-pdf-o file-powerpoint-o file-text file-text-o file-video-o file-word-o),
    spinner: %w(circle-o-notch cog refresh spinner),
    form_control: %w(check-square check-square-o circle circle-o dot-circle-o minus-square minus-square-o plus-square plus-square-o square square-o),
    payment: %w(cc-amex cc-discover cc-mastercard cc-paypal cc-stripe cc-visa credit-card google-wallet paypal),
    chart: %w(area-chart bar-chart line-chart pie-chart),
    currency: %w( btc eur gbp ils inr jpy krw money rub try usd),
    text_editor: %w(align-center align-justify align-left align-right bold chain-broken clipboard columns eraser file file-o file-text file-text-o files-o floppy-o font header indent italic link list list-alt list-ol list-ul outdent paperclip paragraph repeat scissors strikethrough subscript superscript table text-height text-width th th-large th-list underline undo),
    directional: %w(angle-double-down angle-double-left angle-double-right angle-double-up angle-down angle-left angle-right angle-up arrow-circle-down arrow-circle-left arrow-circle-o-down arrow-circle-o-left arrow-circle-o-right arrow-circle-o-up arrow-circle-right arrow-circle-up arrow-down arrow-left arrow-right arrow-up arrows arrows-alt arrows-h arrows-v caret-down caret-left caret-right caret-square-o-down caret-square-o-left caret-square-o-right caret-square-o-up caret-up chevron-circle-down chevron-circle-left chevron-circle-right chevron-circle-up chevron-down chevron-left chevron-right chevron-up hand-o-down hand-o-left hand-o-right hand-o-up long-arrow-down long-arrow-left long-arrow-right long-arrow-up),
    video_player: %w(arrows-alt backward compress eject expand fast-backward fast-forward forward pause play play-circle play-circle-o step-backward step-forward stop youtube-play),
    brand: %w(adn android angellist apple behance behance-square bitbucket bitbucket-square btc buysellads cc-amex cc-discover cc-mastercard cc-paypal cc-stripe cc-visa codepen connectdevelop css3 dashcube delicious deviantart digg dribbble dropbox drupal empire facebook facebook-official facebook-square flickr forumbee foursquare git git-square github github-alt github-square google google-plus google-plus-square google-wallet gratipay hacker-news html5 instagram ioxhost joomla jsfiddle lastfm lastfm-square leanpub linkedin linkedin-square linux maxcdn meanpath medium openid pagelines paypal pied-piper pied-piper-alt pinterest pinterest-p pinterest-square qq rebel reddit reddit-square renren sellsy share-alt share-alt-square shirtsinbulk simplybuilt skyatlas skype slack slideshare soundcloud spotify stack-exchange stack-overflow steam steam-square stumbleupon stumbleupon-circle tencent-weibo trello tumblr tumblr-square twitch twitter twitter-square viacoin vimeo-square vine vk weibo weixin whatsapp windows wordpress xing xing-square yahoo yelp youtube youtube-play youtube-square),
    medical: %w(ambulance h-square heart heart-o heartbeat hospital-o medkit plus-square stethoscope user-md wheelchair)
  }.freeze
  # rubocop:enable Metrics/LineLength
end
