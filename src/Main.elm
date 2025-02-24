{- |
    
    Module      : Main.elm
    Description : Elm source code of the website.
    License     : BSD
    Author      : Michal Spano
    Stability   : experimental

    TODO: avoid hardcoding emojis
    TODO: modularize codebase, split to more files/modules
    FIXME: white dots not appearing (light mode)
-}

module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

-- MAIN
main : Program String Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

-- MODEL
type alias Model =
    { isDarkMode  : Bool
    , lastUpdated : String
    }

init : String -> ( Model, Cmd Msg )
init lastUpdated =
    ( { isDarkMode = True,
        lastUpdated = lastUpdated}, Cmd.none ) -- darkMode ON

-- UPDATE
type Msg
    = ToggleTheme

-- Personal info
name : String
name = "Michal Spano"

nameSlug : String
nameSlug = "michalspano"

-- TODO: write docs
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleTheme ->
            ( { model | isDarkMode = not model.isDarkMode }, Cmd.none )

-- VIEW
view : Model -> Browser.Document Msg
view model =
    { title = name
    , body =
        [ div 
            [ classList
                [ ("container", True)
                , ("dark-mode", model.isDarkMode)
                ]
            ]
            [ themeToggle model.isDarkMode
            , header
            , div [ class "content" ]
                [ intro
                , projects
                , education
                , skills
                , interests
                , footer model
                ]
            ]
        ]
    }

{-| Display the button to toggle dark/light mode. Also toggle the text (i.e.
emoji) that is put to the button that is put to the button
-}
themeToggle : Bool -> Html Msg
themeToggle isDarkMode =
    button 
        [ class "theme-toggle", onClick ToggleTheme ]
        [ text (if isDarkMode then "🌞" else "🌙") ]

{-| Format the header of the website. Add title and social media links.
-}
-- TODO: email contact
-- TODO: consider using https://github.com/Lattyware/elm-fontawesome for icons
header : Html Msg
header =
    div [ class "header header-container animate-fade-in" ]
        [ div [ class "text-container" ]
            [ h1 [] [ text name ]
            , p [ class "title" ] [ text "Functional Programmer & Geek" ]
            , div [ class "social-links" ]
                [ a [ href
                        ("https://github.com/" ++ nameSlug)
                        , target "_blank", class "button social-button"
                    ] [ text "GitHub" ]
                , a [ href
                        ("https://linkedin.com/in/" ++ nameSlug)
                        , target "_blank", class "button social-button"
                    ] [ text "LinkedIn" ]
                {-, a [ href
                        ("https://linkedin.com/in/" ++ nameSlug)
                        , target "_blank", class "social-button"
                    ] [ img [ src "icon.png", class "social-icon" ] []]
                  -}
                ]
            ]
        , div [ class "image-container" ]
            [ img [ src "https://michalspano.com/michalspano.github.io/assets/images/profile.png", class "profile-pic" ] [] ]
        ]


{-| This function creates the introduction text of the website.
-}
-- TODO: add support for some links, boldface, italics, etc.
intro : Html Msg
intro =
    section [ class "section card animate-on-scroll" ]
        [ h2 [] [ text "About Me" ] -- About me, initial words
        , p []
            [ text """
                I'm a passionate Software Engineer and Mathematics enthusiast from
                Slovakia, currently based in Sweden’s Gothenburg. I’m a Student of
                Software Engineering BSc. at the joint department of Computer
                Science and Engineering at Chalmers and Gothenburg University,
                Sweden.
                """
            ]
        , br [] [] -- line break (avoid ugly [] [])
        , p [] -- more about me
            [ text """
                This website is my personal portfolio, where I showcase my
                projects, skills, and experiences. Similarly, I write about my
                journey as a programmer and share my knowledge with others. I also
                plan to use the website to share my thoughts and ideas about the
                world of technology and software development via blog posts.
                   """
            ]
        , div [ class "quote-box" ]
            [
            blockquote [] [
                text """
                     \"The most effective debugging tool is still
                       careful thought, coupled with judiciously
                       placed print statements.\" - Brian Kernighan
                       """
                ]
            ]
        ]

-- FIXME: add the rest of the text
{-
    I <3 open source software and functional λ.
    Besides, I also enjoy computer graphics \& video editing and photography.
    My other hobbies include reading, music, traveling, and taking walks in
    nature.
-}

{-| A function that create an HTML component that displays a project. It
expects strings as input params (title, desc, link).

    projectCard "Portfolio website" "A cool portfolio written in Elm"
                "https://github.com/repo" : -> Html Msg
-}
projectCard : String -> String -> String -> Html Msg
projectCard title description link =
    div [ class "card project-card animate-on-scroll" ]
        [ h3 [] [ text title ]
        , p [] [ text description ]
        , a [ href link, target "_blank", class "button" ] [ text "View Project" ]
        ]

{-| Formats all projects together in a compact way. Add more project to the
inner most array, use @projectCard@ to format each project entry.

    projects [ projectCard ..., projectCard ...] : -> Html Msg
-}
projects : Html Msg
projects =
    section [ class "section animate-on-scroll" ]
        [ h2 [] [ text "Projects" ]
        , div [ class "projects-grid" ]
            [ projectCard 
                "AppointDent"
                """
                A website-based application aimed to assist Swedish residents
                to manage dentist appointments and provides dentists with tools to
                organize their schedules.
                """
                "https://github.com/michalspano/AppointDent"
            , projectCard
                "Past Exams"
                """
                An automated exam archival system with that generates a
                searchable static (Jekyll) website of departmental examination
                materials.
                """
                "https://github.com/johndoe/task-manager"
            , projectCard
                "Dotfiles"
                """
                Customization & configuration files, scripts, environments for Unix & OSX.
                """
                "https://github.com/michalspano/dotfiles"
            -- TODO: add rest of the projects
            ]
        ]

education : Html Msg
education =
    section [ class "section animate-on-scroll" ]
        [ h2 [] [ text "Education" ]
        , div [ class "card education-item" ]
            [ h3 [] [ text "BSc. Software Engineering" ]
            , p [] [ text "Chalmers and Gothenburg University" ] -- no style
            , p [ class "year" ] [ text "2022 - 2025" ]
            ]
        ]

{-| Format an individual item (i.e. a raw string). Can be used for skills or
interests.
    item "Elm is fun" : -> Html Msg
-}
gridItem : String -> Html Msg
gridItem desc =
    div [ class "card skill-item animate-on-scroll" ]
        [ text desc ]

{-| Display all skills in a flexible grid. Use the @gridItem@ helper function
to format each skill.
-}
skills : Html Msg
skills =
    section [ class "section animate-on-scroll" ]
        [ h2 [] [ text "Skills" ]
        , div [ class "item-grid" ]
            (List.map gridItem
                [ "Haskell"
                , "Typescript"
                , "C"
                , "Python"
                , "Git"
                ]
            )
        ]

{-| Display all interests in a flexible grid. Use the @gridItem@ helper function
to format each interest. These could be non-technical too.
-}
interests : Html Msg
interests =
    section [ class "section animate-on-scroll" ]
        [ h2 [] [ text "Interests" ]
        , div [ class "item-grid" ]
            (List.map gridItem
                [ "Reading 📚"
                , "Nature 🌱"
                , "Writing ✍️"
                , "Music 🎵"
                , "Design 🎨"
                ]
            )
        ]

footer : Model -> Html msg
footer model =
    div [ class "footer animate-fade-in" ]
        [ text "..."
        , div []
            [ text ("© " ++ name ++ " | Written in ")
            , a [href "https://elm-lang.org/", target "_blank"] [text "Elm"]
            , text (" | Last updated on " ++ model.lastUpdated)
            ]
        ]

