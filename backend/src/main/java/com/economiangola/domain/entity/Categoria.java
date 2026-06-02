// src/main/java/com/economiangola/domain/entity/Categoria.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "categorias")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Categoria extends BaseEntity {

    @Column(name = "nome", nullable = false, length = 100)
    private String nome;

    @Column(name = "slug", nullable = false, unique = true, length = 150)
    private String slug;

    @Column(name = "descricao", length = 500)
    private String descricao;

    @Column(name = "icone_url", length = 500)
    private String iconeUrl;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_pai_id")
    private Categoria categoriaPai;

    @OneToMany(mappedBy = "categoriaPai", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Categoria> subcategorias = new ArrayList<>();

    @Column(name = "ordem", nullable = false)
    @Builder.Default
    private Integer ordem = 0;

    @Column(name = "activa", nullable = false)
    @Builder.Default
    private Boolean activa = true;
}
