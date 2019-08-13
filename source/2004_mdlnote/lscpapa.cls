%a simple class using the package lscpapa in an article format
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lscpapa}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}
\RequirePackage{lscpapa}
