class Follower < ApplicationRecord
    belongs_to :follower, class_name: "User"  # тот, кто подписывается
    belongs_to :following, class_name: "User" # тот, на кого подписываются
end
