/*=========================================================================

  Library:   CTK
 
  Copyright (c) Kitware Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.commontk.org/LICENSE

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
 
=========================================================================*/

#ifndef __ctkVTKWidgetsAbstractPlugin_h
#define __ctkVTKWidgetsAbstractPlugin_h

// Qt includes
#include <QDesignerCustomWidgetInterface>

// CTK includes
#include "CTKVisualizationVTKWidgetsPluginsExport.h"

class CTK_VISUALIZATION_VTK_WIDGETS_PLUGINS_EXPORT ctkVTKWidgetsAbstractPlugin :
  public QDesignerCustomWidgetInterface
{
  Q_INTERFACES(QDesignerCustomWidgetInterface);
public:

  ctkVTKWidgetsAbstractPlugin();
  
  // Do *NOT* reimplement this method.
  QString group() const;
  
  // You can reimplement these methods
  virtual QIcon icon() const;
  virtual QString toolTip() const;
  virtual QString whatsThis() const;
  virtual void initialize(QDesignerFormEditorInterface *formEditor);
  
protected:
  bool Initialized;
};

#endif
