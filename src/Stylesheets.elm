port module Stylesheets exposing (..)

import Css.File exposing (CssCompilerProgram, CssFileStructure)
import WordGameCss as WordGame


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "wordgame.css", Css.File.compile [ WordGame.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
