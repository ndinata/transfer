echo "Let's set up git."
echo "Type in your first and last name: "
read full_name

echo "Type in your Github email address: "
read email

git config --global user.name $full_name
git config --global user.email $email

echo "Git is all set!"
