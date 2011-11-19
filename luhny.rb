#!/usr/bin/env ruby

$LOAD_PATH << File.dirname(__FILE__)

require 'luhn'


def sample_test
  [ #'56613959932537',
#    '508733740140655',
#    '6853371389452376',
#    '49536290423965',
#    '306903975081421',
#    '6045055735309820',
#    '5872120460121',
#    '99929316122852072',
#    '0003813474535310',
#    '0114762758182750',
#    '9875610591081018250321',
#    '0' * 1000,
#    '4352 7211 4223 5131',
#    '7288-8379-3639-2755',
    'java.lang.FakeException: 7230 3161 3748 4124 is a card #.',
#    "4111 1111 1111 111 doesn't have enough digits.",
#    '56613959932535089 has too many digits.',
  #'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  #'5212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274062113075212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274062113075212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274',
  #'5451496852732996063216961135925002811586537152199011985874232493633063047918301881385483284586533476253043731721256291647129524137724321728426184434461211703740649863341542579718271551110706936707319896126135944655506777360650140073402696573847382312143994860950153547889826890506187544774005026327396239056283010290981735778560515623251759619833225650753259593746554508212002384743816147220901767420098517594528110348433559626620298669171000062321471778438988210772771125375553564585320157635817785646893772472227467874437527001732836456864256454316370375336790286880557855773092293464498480234269658315323895080609167720971257548045968322939533404152970558280322501801922337656360557826932953501196791996392141409716242024358132638936168824328539157595191336754405365165167449323818836023303930252215414173373588852488517005006682091203000533131570369087503070508446066122223326556254899598241462739083519446495374791938334509806165682356091342533772992235963750210739883141610937988149208758059239',
  ].each do |s|
    puts Luhn.new.mask_with_case(s)
  end
end



#sample_test
Luhn.new.tap_stdin




